%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 1 (short names)
%% Wet season, nearby good zone with water
%% Expected outcome: move
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zones
zone(c).    % current zone
zone(g1).   % good nearby zone

% Optional labels for interpretation
label(c,  "Current zone").
label(g1, "Good nearby wet-season zone").

herd(h1).
herd_type(h1, fora).

season(wet).

current(c).
destination(g1).

% Landscape (wet-season usable)
landscape(c,  wayam).
landscape(g1, wayam).

% Current zone
forage(c,  medium).
water(c,   available).
finna(c,   available).
safety(c,  safe).
distance_to_grazing_zone(c,  near).
distance_to_water(c,        near).
reachable(c,                reachable).
access(c,                   accessible).

% Destination: high forage, water, safe, near
forage(g1, high).
water(g1,  available).
finna(g1,  available).
safety(g1, safe).
distance_to_grazing_zone(g1, near).
distance_to_water(g1,       near).
reachable(g1,               reachable).
access(g1,                  accessible).

% Route
route(r1_route).
connects(r1_route, c, g1).
