%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 3
%% Destination is restricted but physically reachable
%% Expected outcome: negotiate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zone(z_current).
zone(z_restricted).

herd(h1).
herd_type(h1, fora).

season(wet).

current(z_current).
destination(z_restricted).

forage(z_current, medium).
water(z_current, available).
finna(z_current, available).
safety(z_current, safe).
distance_to_grazing_zone(z_current, near).
distance_to_water(z_current, near).
reachable(z_current, reachable).
access(z_current, accessible).

forage(z_restricted, high).
water(z_restricted, available).
finna(z_restricted, available).
safety(z_restricted, safe).
distance_to_grazing_zone(z_restricted, near).
distance_to_water(z_restricted, near).
reachable(z_restricted, reachable).
access(z_restricted, inaccessible).

route(r1).
connects(r1, z_current, z_restricted).