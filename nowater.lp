%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 2
%% Destination has good forage but no water
%% Expected outcome: do_not_move
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zone(z_current).
zone(z_no_water).

herd(h1).
herd_type(h1, fora).

season(wet).

current(z_current).
destination(z_no_water).

% Current zone
forage(z_current, medium).
water(z_current, available).
finna(z_current, available).
safety(z_current, safe).
distance_to_grazing_zone(z_current, near).
distance_to_water(z_current, near).
reachable(z_current, reachable).
access(z_current, accessible).

% Destination zone: good pasture, but water absent
forage(z_no_water, high).
water(z_no_water, unavailable).
finna(z_no_water, available).
safety(z_no_water, safe).
distance_to_grazing_zone(z_no_water, near).
distance_to_water(z_no_water, far).
reachable(z_no_water, reachable).
access(z_no_water, accessible).

% Route
route(r1).
connects(r1, z_current, z_no_water).