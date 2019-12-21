function plot_ruler(p1, p2)
x1 = p1(1);y1=p1(2);
x2 = p2(1);y2=p2(2);
plot([x1 + 0.5, x2 + 0.5], [y1 + 0.5, y2 + 0.5],'LineWidth',5,'Color','blue')

y11 = y1 - (x2 - x1);
y12 = y1 + (x2 - x1);
x11 = x1 + (y2 - y1);
x12 = x1 - (y2 - y1);
plot([x11 + 0.5, x12 + 0.5], [y11 + 0.5, y12 + 0.5],'LineWidth',5,'Color','black')

y21 = y2 - (x2 - x1);
y22 = y2 + (x2 - x1);
x21 = x2 + (y2 - y1);
x22 = x2 - (y2 - y1);
plot([x21 + 0.5, x22 + 0.5], [y21 + 0.5, y22 + 0.5],'LineWidth',5,'Color','black')