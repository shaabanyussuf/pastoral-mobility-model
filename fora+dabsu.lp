%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEST: FORA HERD DISTANCE LOGIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

season(wet).
herd(fora).

current(d1,a).
destination(d1,h).
destination(d1,i).

forage(d1,a,moderate).
water(d1,a,available).
finna(d1,a,good).
safety(d1,a,safe).
access(d1,a,open).
distance_to_water(d1,a,near).

forage(d1,h,good).
water(d1,h,available).
finna(d1,h,good).
chisa(d1,h,suitable).
safety(d1,h,safe).
access(d1,h,open).
distance_to_water(d1,h,far).
watering_strategy(d1,h,dabsu).

forage(d1,i,good).
water(d1,i,available).
finna(d1,i,good).
chisa(d1,i,suitable).
safety(d1,i,safe).
access(d1,i,open).
distance_to_water(d1,i,near).

