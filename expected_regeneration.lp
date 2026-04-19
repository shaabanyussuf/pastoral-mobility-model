%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 4
%% Wet season, destination has water but poor forage,
%% and effective rain → expect: wait
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zone(c).     % current
zone(p1).    % poor forage but regenerating

herd(h1).
herd_type(h1, fora).

season(wet).

current(c).
destination(p1).

% Landscape (wet-season usable)
landscape(c,  wayam).
landscape(p1, wayam).

% Current zone (moderate baseline)
forage(c,  medium).
water(c,   available).
finna(c,   available).
safety(c,  safe).
distance_to_grazing_zone(c,  near).
distance_to_water(c,        near).
reachable(c,                reachable).
access(c,                   accessible).

% Destination: poor forage, but water & safety OK, near
forage(p1, low).
water(p1,  available).
finna(p1,  available).
safety(p1, safe).
distance_to_grazing_zone(p1, near).
distance_to_water(p1,       near).
reachable(p1,               reachable).
access(p1,                  accessible).

% Rain at destination → effective_rain(p1)
recent_rain(p1).

% Route
route(r1_route).
connects(r1_route, c, p1).