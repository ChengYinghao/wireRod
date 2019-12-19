# %%

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

from utils import \
    compute_edges, find_parallel, plot_line, initial_points, \
    plot_ruler, compute_grad, lines_mask, compute_score, compute_dp, compute_pan, compute_rot, compute_spring

# %% md

# 1. Image Loading

# %%

img = plt.imread("data/3.jpg")
h, w = np.shape(img)[:2]
l = np.sqrt(w * h)

# %% md

# 2. Hough Transform

# %%

edges = compute_edges(img, l / 100)

# %%

reduce_scale = 16
reduced_edges = edges[::reduce_scale, ::reduce_scale]
bin_threshold = 0.03

(theta1, rho1), (theta2, rho2) = find_parallel(reduced_edges, bin_threshold)
rho1 *= reduce_scale
rho2 *= reduce_scale

# plt.figure()
# plt.imshow(img, extent=(0, w, 0, h))
# plot_line(plt, w, h, theta1, rho1)
# plot_line(plt, w, h, theta2, rho2)
# plt.xlim(0, w)
# plt.ylim(0, h)
# plt.show()

# %%

(x1, y1), (x2, y2) = initial_points(theta1, rho1, theta2, rho2, w, h)

p1 = np.array((x1, h - y1))
p2 = np.array((x2, h - y2))

# plt.figure()
# plt.imshow(img, extent=(0, w, 0, h))
# plot_ruler(plt, p1, p2)
# plt.xlim(0, w)
# plt.ylim(0, h)
# plt.show()

# %% md

# 3. Gradient Decent

# %%

# todo reduce img to accelerate the gradient decent

# %%

grad = compute_grad(edges, l / 100)

# plt.imshow(grad[:, :, 1], extent=(0, w, 0, h))

# %%

ps = np.stack(np.meshgrid(np.arange(w), np.flip(np.arange(h))), -1)

# %%

# 加扰动
p1 += np.random.uniform(-1, 1, [2]) * l / 50
p2 += np.random.uniform(-1, 1, [2]) * l / 50

# plt.figure()
# plt.imshow(img, extent=(0, w, 0, h))
# plot_ruler(plt, p1, p2)
# plt.xlim(0, w)
# plt.ylim(0, h)
# plt.show()

v1 = 0
v2 = 0

scores = []
movements = []

# %%

decent_rate = 1.0
momentum = 1
damping = 0.5

thickness = 5
expand = 3

pan_m = 0.001 * l * (thickness + expand)
rot_m = 0.002 * l * l * (thickness + expand)
spr_m = 0.1 * l

# %%

fig = plt.figure(figsize=(10, 5))
ax_img = plt.subplot2grid((2, 3), (0, 0), rowspan=2, colspan=2)
ax_mov = plt.subplot2grid((2, 3), (0, 2))
ax_scr = plt.subplot2grid((2, 3), (1, 2))
plt.tight_layout()


def step(i):
    global p1, p2, v1, v2
    
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
    
    dp1_spr, dp2_spr = compute_spring(p1, p2, spr_m, l / 50, l / 10)
    dp1 += dp1_spr
    dp2 += dp2_spr
    
    v1 += dp1 * decent_rate / momentum
    v2 += dp2 * decent_rate / momentum
    
    v1 *= 1.0 - damping
    v2 *= 1.0 - damping
    
    p1 += v1
    p2 += v2
    
    movement = np.sqrt(np.sum(np.square(v1))) + np.sqrt(np.sum(np.square(v2)))
    movements.append(movement)
    
    score = compute_score(mask_all, edges) * (10 ** 4)
    # score = compute_score(mask_all,edges)
    scores.append(score)
    
    print(f"step={len(movements)}, movement={movement:.2f}, score={score:.2f}")
    plot()
    
    if len(movements) > 5:
        if np.mean(np.array(movements[-5:])) <= 0.15:
            animate.event_source.stop()


def plot():
    ax_img.clear()
    ax_img.imshow(img, extent=(0, w, 0, h))
    plot_ruler(ax_img, p1, p2)
    ax_img.set_xlim(0, w)
    ax_img.set_ylim(0, h)
    
    ax_mov.clear()
    ax_mov.set_ylabel("movement")
    ax_mov.plot(movements)
    
    ax_scr.clear()
    ax_scr.set_ylabel("score")
    ax_scr.plot(scores)


# %%

plot()
plt.ion()
plt.show()

animate = FuncAnimation(fig, step, frames=None, fargs=None)
