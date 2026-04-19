%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 2 (short names)
%% Destination has good forage but no water
%% Expected outcome: do_not_move
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zones
zone(c).    % current zone
zone(nw).   % no-water zone

% Optional human-readable labels (ignored by rules)
label(c,  "Current zone").
label(nw, "No-water zone").

herd(h1).
herd_type(h1, fora).

season(wet).

current(c).
destination(nw).

% Landscape (both usable in wet season)
landscape(c,  wayam).
landscape(nw, wayam).

% Current zone
forage(c,  medium).
water(c,   available).
finna(c,   available).
safety(c,  safe).
distance_to_grazing_zone(c,  near).
distance_to_water(c,        near).
reachable(c,                reachable).
access(c,                   accessible).

% Destination zone: good pasture, but water absent
forage(nw, high).
water(nw,  unavailable).
finna(nw,  available).
safety(nw, safe).
distance_to_grazing_zone(nw, near).
distance_to_water(nw,       far).
reachable(nw,               reachable).
access(nw,                  accessible).

% Route
route(r1).
connects(r1, c, nw).
