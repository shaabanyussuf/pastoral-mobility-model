%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 3
%% Destination has no water
%% Expected outcome: do_not_move(d1,a,g)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

season(wet).

% Current location
current(d1,a).

% Destination under consideration
destination(d1,g).

% Current area conditions (optional unless needed later)
forage(d1,a,moderate).
water(d1,a,available).
finna(d1,a,good).
safety(d1,a,safe).
access(d1,a,open).
distance_to_water(d1,a,near).

% Destination conditions
forage(d1,g,good).
water(d1,g,none).
finna(d1,g,good).
safety(d1,g,safe).
access(d1,g,open).
distance_to_water(d1,g,far).
