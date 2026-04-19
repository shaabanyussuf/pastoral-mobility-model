%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RULE ENCODING LAYER
%% Core decision logic only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. MOVEMENT ABSTRACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Actions are primary; decision/3 is a view.
decision(Zc, Zd, move)        :- move(Zc, Zd).
decision(Zc, Zd, wait)        :- wait(Zc, Zd).
decision(Zc, Zd, do_not_move) :- do_not_move(Zc, Zd).
decision(Zc, Zd, negotiate)   :- negotiate(Zc, Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. SUITABILITY RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Water is non-negotiable for destination suitability.
water_ok(Zd) :-
    destination(Zd),
    has_water(Zd).

% Normal (non-drought) suitability.
% Safety is handled separately through blocked_by_safety/1.
suitable_normal(Zd) :-
    destination(Zd),
    seasonally_suitable(Zd),
    water_ok(Zd),
    good_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd),
    institutionally_open(Zd),
    not drought_ctx.

suitable_normal(Zd) :-
    destination(Zd),
    seasonally_suitable(Zd),
    water_ok(Zd),
    moderate_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd),
    institutionally_open(Zd),
    not drought_ctx.

% Drought relaxation.
suitable_drought(Zd) :-
    destination(Zd),
    drought_ctx,
    seasonally_suitable(Zd),
    water_ok(Zd),
    poor_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd).

suitable_drought(Zd) :-
    destination(Zd),
    drought_ctx,
    seasonally_suitable(Zd),
    water_ok(Zd),
    moderate_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd).

candidate_for_movement(Zd) :- suitable_normal(Zd).
candidate_for_movement(Zd) :- suitable_drought(Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2A. DROUGHT RESERVE FLAG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drought_reserve_candidate(Zd) :-
    destination(Zd),
    drought_ctx,
    seasonal_reserve(Zd, drought),
    candidate_for_movement(Zd),
    route_ok(Zc, Zd),
    not blocked_by_access(Zd),
    not blocked_by_route(Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. ROUTE / ORIGIN-DESTINATION FEASIBILITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

route_ok(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    path(Zc, Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. BLOCKING CONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Safety block.
blocked_by_safety(Zd) :-
    destination(Zd),
    unsafe_zone(Zd),
    not drought_ctx.

% Institutional access block.
blocked_by_access(Zd) :-
    destination(Zd),
    restricted_zone(Zd),
    not drought_ctx.

% Physical connectivity block.
blocked_by_route(Zd) :-
    destination(Zd),
    blocked_zone(Zd).

% Seasonal reserve block (closed in normal times).
blocked_by_reserve(Zd) :-
    destination(Zd),
    seasonal_reserve(Zd, S),
    season(S),
    not drought_ctx.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. NEGOTIATION RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Negotiation when access is restricted but otherwise usable.
negotiate(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    restricted_zone(Zd),
    water_ok(Zd),
    supports_finna(Zd),
    physically_reachable(Zd),
    route_ok(Zc, Zd),
    not blocked_by_safety(Zd),
    not blocked_by_route(Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. MOVE / WAIT / DO NOT MOVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MOVE: all suitability conditions + route ok + no blocks.
move(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    candidate_for_movement(Zd),
    route_ok(Zc, Zd),
    not blocked_by_safety(Zd),
    not blocked_by_access(Zd),
    not blocked_by_route(Zd),
    not blocked_by_reserve(Zd),
    not do_not_move(Zc, Zd).

% WAIT: low forage, but rain suggests likely regeneration.
wait(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    water_ok(Zd),
    poor_forage(Zd),
    effective_rain(Zd),
    not do_not_move(Zc, Zd),
    not negotiate(Zc, Zd).

% DO NOT MOVE conditions.
do_not_move(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    no_water(Zd).

do_not_move(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    poor_finna(Zd),
    not drought_ctx.

do_not_move(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    blocked_by_safety(Zd).

do_not_move(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    blocked_by_route(Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7. DECISION CONSISTENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- move(Zc, Zd), wait(Zc, Zd).
:- move(Zc, Zd), do_not_move(Zc, Zd).
:- move(Zc, Zd), negotiate(Zc, Zd).
:- wait(Zc, Zd), do_not_move(Zc, Zd).
:- wait(Zc, Zd), negotiate(Zc, Zd).
:- do_not_move(Zc, Zd), negotiate(Zc, Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8. DEFAULT WAIT UNDER UNCERTAINTY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wait(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    not move(Zc, Zd),
    not do_not_move(Zc, Zd),
    not negotiate(Zc, Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9. OPTIMISATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prefer high forage over moderate forage.
:~ move(Zc, Zd), moderate_forage(Zd). [1@2, Zc, Zd]
:~ move(Zc, Zd), good_forage(Zd).     [0@2, Zc, Zd]

% Prefer near grazing and near water.
:~ move(Zc, Zd), far_grazing(Zd).  [1@1, Zc, Zd]
:~ move(Zc, Zd), near_grazing(Zd). [0@1, Zc, Zd]

:~ move(Zc, Zd), far_water(Zd).    [1@1, Zc, Zd]
:~ move(Zc, Zd), near_water(Zd).   [0@1, Zc, Zd]

% In drought, prefer drought reserves over non-reserve destinations.
:~ move(Zc, Zd), drought_ctx, not seasonal_reserve(Zd, drought). [2@3, Zc, Zd]

% In drought, prefer safe destinations over unsafe ones.
:~ move(Zc, Zd), drought_ctx, unsafe_zone(Zd). [1@2, Zc, Zd]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 10. OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show current/1.
#show destination/1.
#show seasonal_reserve/2.
#show drought_reserve_candidate/1.
#show move/2.
#show wait/2.
#show do_not_move/2.
#show negotiate/2.
#show decision/3.
