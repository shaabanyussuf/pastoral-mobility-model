%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTANCE TEST 1
%% Wet season, seasonally suitable destination with water
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

season(wet).

% Current location
current(d1,a).

% Destination under consideration
destination(d1,g).

% Current area conditions (optional unless you use them later)
forage(d1,a,moderate).
water(d1,a,available).
finna(d1,a,good).
safety(d1,a,safe).
access(d1,a,open).
distance_to_water(d1,a,near).

% Destination conditions
forage(d1,g,good).
water(d1,g,available).
finna(d1,g,good).
safety(d1,g,safe).
access(d1,g,open).
distance_to_water(d1,g,near).
