%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RULE ENCODING LAYER
%% DEDHA-SPECIFIC DECISION LOGIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. MOVEMENT ABSTRACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

decision(D,Zc,Zd,move) :-
    move(D,Zc,Zd).

decision(D,Zc,Zd,wait) :-
    wait(D,Zc,Zd).

decision(D,Zc,Zd,do_not_move) :-
    do_not_move(D,Zc,Zd).

decision(D,Zc,Zd,negotiate) :-
    negotiate(D,Zc,Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. SUITABILITY RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Water adequacy
water_sufficient(D,Zd) :-
    destination(D,Zd),
    has_water(D,Zd).

water_insufficient(D,Zd) :-
    destination(D,Zd),
    no_water(D,Zd).

water_insufficient(D,Zd) :-
    destination(D,Zd),
    scarce_water(D,Zd),
    not drought_ctx.

% Distance-to-water manageability
distance_manageable(D,Zd) :-
    destination(D,Zd),
    near_water(D,Zd).

distance_manageable(D,Zd) :-
    destination(D,Zd),
    far_water(D,Zd),
    has_dabsu(D,Zd).

distance_manageable(D,Zd) :-
    destination(D,Zd),
    far_water(D,Zd),
    has_limalim(D,Zd).

% Final water condition
water_ok(D,Zd) :-
    destination(D,Zd),
    water_sufficient(D,Zd),
    distance_manageable(D,Zd).

 

needs_rescout(D,Zd) :-
    destination(D,Zd),
    conflicting_report(D,Zd).    

% Normal suitability
suitable_normal(D,Zd) :-
    destination(D,Zd),
    seasonally_suitable(D,Zd),
    water_ok(D,Zd),
    good_forage(D,Zd),
    supports_finna(D,Zd),
    physically_reachable(D,Zd),
    institutionally_open(D,Zd),
    not drought_ctx.

suitable_normal(D,Zd) :-
    destination(D,Zd),
    seasonally_suitable(D,Zd),
    water_ok(D,Zd),
    moderate_forage(D,Zd),
    supports_finna(D,Zd),
    physically_reachable(D,Zd),
    institutionally_open(D,Zd),
    not drought_ctx.

% Drought relaxation
suitable_drought(D,Zd) :-
    destination(D,Zd),
    drought_ctx,
    seasonally_suitable(D,Zd),
    water_ok(D,Zd),
    poor_forage(D,Zd),
    supports_finna(D,Zd),
    physically_reachable(D,Zd).

suitable_drought(D,Zd) :-
    destination(D,Zd),
    drought_ctx,
    seasonally_suitable(D,Zd),
    water_ok(D,Zd),
    moderate_forage(D,Zd),
    supports_finna(D,Zd),
    physically_reachable(D,Zd).

candidate_for_movement(D,Zd) :- suitable_normal(D,Zd).
candidate_for_movement(D,Zd) :- suitable_drought(D,Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. ROUTE / ORIGIN-DESTINATION FEASIBILITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

route_ok(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    physically_reachable(D,Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. BLOCKING CONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

blocked_by_safety(D,Zd) :-
    destination(D,Zd),
    unsafe_zone(D,Zd),
    not drought_ctx.

blocked_by_access(D,Zd) :-
    destination(D,Zd),
    restricted_zone(D,Zd),
    not drought_ctx.

blocked_by_route(D,Zd) :-
    destination(D,Zd),
    unreachable(D,Zd).

blocked_by_reserve(D,Zd) :-
    destination(D,Zd),
    drought_reserve(D,Zd),
    not drought_ctx,
    not reserve_open(D,Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. NEGOTIATION RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

negotiate(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    restricted_zone(D,Zd),
    candidate_for_movement(D,Zd),
    route_ok(D,Zc,Zd),
    not blocked_by_safety(D,Zd),
    not blocked_by_route(D,Zd),
    not blocked_by_reserve(D,Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. MOVE / WAIT / DO NOT MOVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eligible movement options
movable_option(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    candidate_for_movement(D,Zd),
    route_ok(D,Zc,Zd),
    not blocked_by_safety(D,Zd),
    not blocked_by_access(D,Zd),
    not blocked_by_route(D,Zd),
    not blocked_by_reserve(D,Zd),
        not needs_rescout(D,Zd),
    not do_not_move(D,Zc,Zd).

% Select exactly one move if at least one movable option exists
1 { selected_move(D,Zc,Zd) : movable_option(D,Zc,Zd) } 1 :-
    current(D,Zc),
    1 { movable_option(D,Zc,Zd) : destination(D,Zd) }.

move(D,Zc,Zd) :-
    selected_move(D,Zc,Zd).

% WAIT: poor forage but expected regeneration after rain
wait(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    water_ok(D,Zd),
    poor_forage(D,Zd),
    effective_rain(D,Zd),
    not do_not_move(D,Zc,Zd),
    not negotiate(D,Zc,Zd),
    not move(D,Zc,Zd).

    wait(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    needs_rescout(D,Zd),
    not do_not_move(D,Zc,Zd),
    not negotiate(D,Zc,Zd),
    not move(D,Zc,Zd).

% DO NOT MOVE conditions
do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    water_insufficient(D,Zd).

do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    far_water(D,Zd),
    not distance_manageable(D,Zd).

 do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    not seasonally_suitable(D,Zd),
    not drought_ctx.   

do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    herd(warra),
    far_route(D,Zc,Zd),
    not drought_ctx.    

do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    poor_finna(D,Zd),
    not drought_ctx.

do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    blocked_by_safety(D,Zd).

do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    blocked_by_route(D,Zd).

do_not_move(D,Zc,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    too_far(D,Zd),
    not drought_ctx.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7. DECISION CONSISTENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- move(D,Zc,Zd), wait(D,Zc,Zd).
:- move(D,Zc,Zd), do_not_move(D,Zc,Zd).
:- move(D,Zc,Zd), negotiate(D,Zc,Zd).
:- wait(D,Zc,Zd), do_not_move(D,Zc,Zd).
:- wait(D,Zc,Zd), negotiate(D,Zc,Zd).
:- do_not_move(D,Zc,Zd), negotiate(D,Zc,Zd).

:- decision(D,Zc,Zd,A1), decision(D,Zc,Zd,A2), A1 != A2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8. OPTIMISATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prefer good forage over moderate forage
:~ move(D,Zc,Zd), moderate_forage(D,Zd). [1@2,D,Zc,Zd]
:~ move(D,Zc,Zd), good_forage(D,Zd).     [0@2,D,Zc,Zd]

% Prefer near over far
:~ move(D,Zc,Zd), far_route(D,Zc,Zd).  [1@1,D,Zc,Zd]
:~ move(D,Zc,Zd), near_route(D,Zc,Zd). [0@1,D,Zc,Zd]

% Prefer near water over far water
:~ move(D,Zc,Zd), far_water(D,Zd).  [1@1,D,Zc,Zd]
:~ move(D,Zc,Zd), near_water(D,Zd). [0@1,D,Zc,Zd]

% In drought, prefer drought reserves
:~ move(D,Zc,Zd), drought_ctx, not drought_reserve(D,Zd). [2@3,D,Zc,Zd]

% In drought, still prefer safe destinations when possible
:~ move(D,Zc,Zd), drought_ctx, unsafe_zone(D,Zd). [1@2,D,Zc,Zd]

% Prefer destinations with suitable camp conditions
:~ move(D,Zc,Zd), no_chisa(D,Zd).  [1@1,D,Zc,Zd]
:~ move(D,Zc,Zd), has_chisa(D,Zd). [0@1,D,Zc,Zd]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9. OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show movable_option/3.
#show move/3.
#show wait/3.
#show do_not_move/3.
#show negotiate/3.
#show decision/4.
#show candidate_for_movement/2.
#show blocked_by_route/2.
#show blocked_by_access/2.
#show blocked_by_safety/2.
#show blocked_by_reserve/2.
#show water_ok/2.
#show suitable_normal/2.
#show suitable_drought/2.
#show route_ok/3.
