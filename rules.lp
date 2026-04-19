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

% Normal (non-drought) suitability:
% Note: safety is NOT checked here; handled via blocked_by_safety.
suitable_normal(Zd) :-
    destination(Zd),
    water_ok(Zd),
    good_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd),
    institutionally_open(Zd),
    not drought_ctx.

suitable_normal(Zd) :-
    destination(Zd),
    water_ok(Zd),
    moderate_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd),
    institutionally_open(Zd),
    not drought_ctx.

% Drought relaxation:
suitable_drought(Zd) :-
    destination(Zd),
    drought_ctx,
    water_ok(Zd),
    poor_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd).

suitable_drought(Zd) :-
    destination(Zd),
    drought_ctx,
    water_ok(Zd),
    moderate_forage(Zd),
    supports_finna(Zd),
    physically_reachable(Zd).

candidate_for_movement(Zd) :- suitable_normal(Zd).
candidate_for_movement(Zd) :- suitable_drought(Zd).

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

% Safety block (your chosen place for safety).
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
    seasonal_reserve(Zd),
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

% Specific WAIT cases:
% a) wet season, low forage but water present -> wait for regeneration.
wait(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    water_ok(Zd),
    poor_forage(Zd),
    season(wet).

% b) otherwise suitable but we are conservative (fallback wait).
wait(Zc, Zd) :-
    current(Zc),
    destination(Zd),
    water_ok(Zd),
    moderate_forage(Zd),
    supports_finna(Zd),
    not move(Zc, Zd),
    not do_not_move(Zc, Zd),
    not negotiate(Zc, Zd).

% DO NOT MOVE conditions:
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
%% 9. OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show current/1.
#show destination/1.
#show move/2.
#show wait/2.
#show do_not_move/2.
#show negotiate/2.
#show decision/3.