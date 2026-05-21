%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BLOCKED ROUTE SCENARIO
%% Wet season, destination is suitable but unreachable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

season(wet).

current(d1,a).
destination(d1,i).

forage(d1,a,moderate).
water(d1,a,available).
finna(d1,a,good).
safety(d1,a,safe).
access(d1,a,open).
distance_to_water(d1,a,near).

forage(d1,i,good).
water(d1,i,available).
finna(d1,i,good).
safety(d1,i,safe).
access(d1,i,open).
distance_to_water(d1,i,near).

blocked_route(d1,a,b).
blocked_route(d1,a,f).