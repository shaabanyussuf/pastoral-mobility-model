%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BASE ENCODING LAYER
%% Pastoral mobility / grazing-zone decision model
%% Neutral ontology + typing + integrity constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. VALUE DOMAINS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

season_value(wet; dry; drought).

herd_kind(warra; fora).

forage_value(high; medium; low).
water_value(available; unavailable).
finna_value(available; unavailable).
safety_value(safe; unsafe).

dist_grazing_value(near; far).
dist_water_value(near; far).

reachability_value(reachable; unreachable).
access_value(accessible; inaccessible).

decision_value(move; wait; do_not_move; negotiate).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. CORE ENTITIES (FACTS COME FROM INSTANCE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example expected extensional facts in instance file:
% zone(z1). zone(z2). zone(z3).
% herd(h1). herd(h2).
% route(r1).
% season(wet).
% herd_type(h1, warra).
% forage(z1, high). water(z1, available). finna(z1, available).
% safety(z1, safe).
% distance_to_grazing_zone(z1, near).
% distance_to_water(z1, near).
% reachable(z1, reachable).
% access(z1, accessible).
% connects(r1, z1, z2).
% current(z1).
% destination(z2).
% seasonal_reserve(z2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. TYPE CHECKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- herd_type(H,T), not herd(H).
:- herd_type(H,T), not herd_kind(T).

:- forage(Z,F), not zone(Z).
:- forage(Z,F), not forage_value(F).

:- water(Z,W), not zone(Z).
:- water(Z,W), not water_value(W).

:- finna(Z,V), not zone(Z).
:- finna(Z,V), not finna_value(V).

:- safety(Z,Sf), not zone(Z).
:- safety(Z,Sf), not safety_value(Sf).

:- distance_to_grazing_zone(Z,D), not zone(Z).
:- distance_to_grazing_zone(Z,D), not dist_grazing_value(D).

:- distance_to_water(Z,WD), not zone(Z).
:- distance_to_water(Z,WD), not dist_water_value(WD).

:- reachable(Z,R), not zone(Z).
:- reachable(Z,R), not reachability_value(R).

:- access(Z,A), not zone(Z).
:- access(Z,A), not access_value(A).

:- current(Z), not zone(Z).
:- destination(Z), not zone(Z).

:- decision(Zc,Zd,D), not zone(Zc).
:- decision(Zc,Zd,D), not zone(Zd).
:- decision(Zc,Zd,D), not decision_value(D).

:- route(R), connects(R,Z1,Z2), not zone(Z1).
:- route(R), connects(R,Z1,Z2), not zone(Z2).
:- connects(R,Z1,Z2), not route(R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. FUNCTIONAL UNIQUENESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- herd_type(H,T1), herd_type(H,T2), T1 != T2.

:- season(S1), season(S2), S1 != S2.

:- forage(Z,F1), forage(Z,F2), F1 != F2.
:- water(Z,W1), water(Z,W2), W1 != W2.
:- finna(Z,V1), finna(Z,V2), V1 != V2.
:- safety(Z,S1), safety(Z,S2), S1 != S2.
:- distance_to_grazing_zone(Z,D1), distance_to_grazing_zone(Z,D2), D1 != D2.
:- distance_to_water(Z,W1), distance_to_water(Z,W2), W1 != W2.
:- reachable(Z,R1), reachable(Z,R2), R1 != R2.
:- access(Z,A1), access(Z,A2), A1 != A2.

:- current(Z1), current(Z2), Z1 != Z2.
:- destination(Z1), destination(Z2), Z1 != Z2.

% :- decision(Zc,Zd,D1), decision(Zc,Zd,D2), D1 != D2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. DERIVED BOOLEAN VIEWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

good_forage(Z)      :- forage(Z, high).
moderate_forage(Z)  :- forage(Z, medium).
poor_forage(Z)      :- forage(Z, low).

has_water(Z)        :- water(Z, available).
no_water(Z)         :- water(Z, unavailable).

supports_finna(Z)   :- finna(Z, available).
poor_finna(Z)       :- finna(Z, unavailable).

safe_zone(Z)        :- safety(Z, safe).
unsafe_zone(Z)      :- safety(Z, unsafe).

near_grazing(Z)     :- distance_to_grazing_zone(Z, near).
far_grazing(Z)      :- distance_to_grazing_zone(Z, far).

near_water(Z)       :- distance_to_water(Z, near).
far_water(Z)        :- distance_to_water(Z, far).

physically_reachable(Z) :- reachable(Z, reachable).
blocked_zone(Z)         :- reachable(Z, unreachable).

institutionally_open(Z) :- access(Z, accessible).
restricted_zone(Z)      :- access(Z, inaccessible).

warra(H) :- herd_type(H, warra).
fora(H)  :- herd_type(H, fora).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. CONTEXT LAYER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drought_ctx :- season(drought).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7. ROUTE / CONNECTIVITY LAYER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

connected(Z1,Z2) :- connects(R,Z1,Z2).
connected(Z2,Z1) :- connects(R,Z1,Z2).

path(Z1,Z2) :- connected(Z1,Z2).
path(Z1,Z3) :- path(Z1,Z2), connected(Z2,Z3), Z1 != Z3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8. OUTPUT CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show zone/1.
#show herd/1.
#show herd_type/2.
#show season/1.
#show current/1.
#show destination/1.

#show forage/2.
#show water/2.
#show finna/2.
#show safety/2.
#show distance_to_grazing_zone/2.
#show distance_to_water/2.
#show reachable/2.
#show access/2.
#show seasonal_reserve/1.

#show route/1.
#show connects/3.
#show connected/2.
#show path/2.

#show decision/3.
#show move/2.
#show wait/2.
#show do_not_move/2.
#show negotiate/2.