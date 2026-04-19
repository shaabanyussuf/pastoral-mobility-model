zone(z_current).
zone(z_good_near).

herd(h1).
herd_type(h1, fora).

season(wet).

current(z_current).
destination(z_good_near).

forage(z_current, medium).
water(z_current, available).
finna(z_current, available).
safety(z_current, safe).
distance_to_grazing_zone(z_current, near).
distance_to_water(z_current, near).
reachable(z_current, reachable).
access(z_current, accessible).

forage(z_good_near, high).
water(z_good_near, available).
finna(z_good_near, available).
safety(z_good_near, safe).
distance_to_grazing_zone(z_good_near, near).
distance_to_water(z_good_near, near).
reachable(z_good_near, reachable).
access(z_good_near, accessible).

route(r1).
connects(r1, z_current, z_good_near).