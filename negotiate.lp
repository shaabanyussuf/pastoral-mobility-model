%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 3 (short names)
%% Destination is restricted but physically reachable
%% Expected outcome: negotiate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zones
zone(c).    % current zone
zone(r1).   % restricted zone

% Optional labels for interpretation
label(c,  "Current zone").
label(r1, "Restricted access zone").

herd(h1).
herd_type(h1, fora).

season(wet).

current(c).
destination(r1).

% Landscape (wet-season usable)
landscape(c,  wayam).
landscape(r1, wayam).

% Current zone
forage(c,  medium).
water(c,   available).
finna(c,   available).
safety(c,  safe).
distance_to_grazing_zone(c,  near).
distance_to_water(c,        near).
reachable(c,                reachable).
access(c,                   accessible).

% Destination zone: good but institutionally restricted
forage(r1, high).
water(r1,  available).
finna(r1,  available).
safety(r1, safe).
distance_to_grazing_zone(r1, near).
distance_to_water(r1,       near).
reachable(r1,               reachable).
access(r1,                  inaccessible).

% Route
route(r1_route).
connects(r1_route, c, r1).
