import numpy as np
import matplotlib.pyplot as plt
from skimage.filters import sobel_h, sobel_v, gaussian
from skimage.transform import hough_line, hough_line_peaks


# edges & gradients

def compute_edges(img, blur=5):
    img = gaussian(img, blur, multichannel=True)
    components = []
    for c in range(np.shape(img)[-1]):
        components.append(sobel_h(img[:, :, c]))
        components.append(sobel_v(img[:, :, c]))
    components = np.array(components)
    edges = np.sqrt(np.sum(np.square(components), 0))
    return edges


def compute_grad(edges, blur=25):
    edges = gaussian(edges, blur)
    grad = np.stack([sobel_v(edges), -sobel_h(edges)], -1)
    return grad


# hough

def find_parallel(edges, bin_threshold=0.03, degree_acc=1, hough_blur=1):
    edges = edges > bin_threshold
    
    tested_angles = np.linspace(-np.pi / 2, np.pi / 2, np.ceil(180 / degree_acc))
    hough, theta, rho = hough_line(edges, tested_angles)
    
    hough = gaussian(hough, hough_blur)
    
    hs, thetas, rhos = hough_line_peaks(hough, theta, rho)
    peaks = zip(hs, thetas, rhos)
    peaks = sorted(peaks, key=lambda p: p[0], reverse=True)
    peaks = tuple(peaks)
    
    _, theta1, rho1 = peaks[0]
    _, theta2, rho2 = peaks[1]
    return (theta1, rho1), (theta2, rho2)


def initial_points(theta1, rho1, theta2, rho2, width, height):
    theta = (theta1 + theta2) / 2
    rho = (rho1 + rho2) / 2
    
    sin_theta = np.sin(theta)
    cos_theta = np.cos(theta)
    
    xc = width / 2
    yc = height / 2
    
    xpc = xc * sin_theta * sin_theta + cos_theta * (rho - yc * sin_theta)
    ypc = yc * cos_theta * cos_theta + sin_theta * (rho - xc * cos_theta)
    
    pc = np.array((xpc, ypc))
    n = np.array((cos_theta, sin_theta))
    d = (rho1 - rho2) / 2
    p1 = pc + n * d
    p2 = pc - n * d
    
    return p1, p2


def plot_line(gca, width, height, theta, rho, color='black'):
    if (theta + np.pi / 4) % np.pi <= np.pi / 2:
        xs = np.array((0, width))
        ys = (rho - xs * np.cos(theta)) / np.sin(theta)
    else:
        ys = np.array((0, height))
        xs = (rho - ys * np.sin(theta)) / np.cos(theta)
    gca.plot(xs, height - ys, color=color)


# gradient

def lines_mask(p1, p2, ps, thickness=1, expand=3):
    dp = p2 - p1
    l = np.sqrt(np.sum(np.square(dp), -1))
    n = dp / l
    m = n @ np.array([[0, -1], [1, 0]])
    
    d1 = np.abs(np.sum((ps - p1) * n, -1))
    d2 = np.abs(np.sum((ps - p2) * n, -1))
    dl = np.abs(np.sum((ps - p1) * m, -1))
    
    line1 = np.clip(thickness / 2 - d1 + expand, 0.0, expand) / expand
    line2 = np.clip(thickness / 2 - d2 + expand, 0.0, expand) / expand
    
    cut = np.clip(l - dl + expand, 0.0, expand) / expand
    line1 *= cut
    line2 *= cut
    
    return line1, line2


def compute_pan(grad, mask, pan_m):
    # todo use array mask to reduce computation
    mask = np.expand_dims(mask, -1)
    pan = np.sum(grad * mask, (0, 1))
    pan = pan / pan_m
    return pan


def compute_rot(p1, p2, ps, grad, mask, rot_m, max_rot=1):
    pc = (p1 + p2) / 2
    pd = ps - pc
    
    rot = np.cross(grad, pd)
    rot = np.sum(rot * mask, (0, 1))
    
    rot = rot / rot_m
    max_rot = np.pi / 180 * max_rot
    if rot > max_rot:
        rot = max_rot
    elif rot < -max_rot:
        rot = -max_rot
    
    rm = np.array([
        [np.cos(rot), -np.sin(rot)],
        [np.sin(rot), np.cos(rot)]
    ])
    
    dp1 = p1 - pc
    dp2 = p2 - pc
    dp1 = dp1 @ rm - dp1
    dp2 = dp2 @ rm - dp2
    
    return dp1, dp2


def compute_spring(p1, p2, spr_m, lower=None, upper=None, rebound=0.0):
    if upper is None:
        upper = lower
    
    l = np.sqrt(np.sum(np.square(p1 - p2)))
    if lower is not None:
        dl_lower = lower - l
        if dl_lower > 0:
            dp1 = (p1 - p2) * (dl_lower + rebound)
            dp2 = -dp1
            return dp1 / spr_m, dp2 / spr_m
    elif upper is not None:
        dl_upper = l - upper
        if dl_upper > 0:
            dp1 = (p2 - p1) * (dl_upper + rebound)
            dp2 = -dp1
            return dp1 / spr_m, dp2 / spr_m
    return np.zeros(2, np.float), np.zeros(2, np.float)


def compute_dp(p1, p2, ps, grad, pan_m, rot_m, spr_m, thickness=1, expand=3, dis_range=(50, 150), rebound=10):
    mask1, mask2 = lines_mask(p1, p2, ps, thickness, expand)
    mask_all = mask1 + mask2
    
    dp1 = 0
    dp2 = 0
    
    dp1_pan = compute_pan(grad, mask1, pan_m)
    dp2_pan = compute_pan(grad, mask2, pan_m)
    dp1 += dp1_pan
    dp2 += dp2_pan
    
    dp1_rot, dp2_rot = compute_rot(p1, p2, ps, grad, mask_all, rot_m)
    dp1 += dp1_rot
    dp2 += dp2_rot
    
    dp1_spr, dp2_spr = compute_spring(p1, p2, spr_m, dis_range[0], dis_range[1], rebound)
    dp1 += dp1_spr
    dp2 += dp2_spr
    
    return dp1, dp2


def compute_score(mask, edges):
    score = np.mean(mask * edges)
    return score


def plot_ruler(gca, p1, p2, line_color='black', bridge_color='blue'):
    x1, y1 = p1
    x2, y2 = p2
    gca.plot((x1 + 0.5, x2 + 0.5), (y1 + 0.5, y2 + 0.5), color=bridge_color)
    
    y11 = y1 - (x2 - x1)
    y12 = y1 + (x2 - x1)
    x11 = x1 + (y2 - y1)
    x12 = x1 - (y2 - y1)
    gca.plot((x11 + 0.5, x12 + 0.5), (y11 + 0.5, y12 + 0.5), color=line_color)
    
    y21 = y2 - (x2 - x1)
    y22 = y2 + (x2 - x1)
    x21 = x2 + (y2 - y1)
    x22 = x2 - (y2 - y1)
    gca.plot((x21 + 0.5, x22 + 0.5), (y21 + 0.5, y22 + 0.5), color=line_color)
