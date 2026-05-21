%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEST: SEASON MISMATCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

season(dry).
herd(fora).

current(d1,a).
destination(d1,h).

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
distance_to_water(d1,h,near).

report_status(d1,h,clear).