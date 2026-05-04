%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BASE ENCODING: DEDHA-SPECIFIC GROUNDED LANDSCAPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. CORE ENTITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dedha(d1;d2).
grazing_area(a;b;c;d;e;f;g;h;i).

% Area membership
area(D,Z) :-
    dedha(D),
    grazing_area(Z).

% To be given in scenario files:
% current(D,Z).
% destination(D,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. VALUE DOMAINS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

landscape_type(baada;caafa;malbe;wayam;omar).
forage_value(good;moderate;poor).
water_value(available;scarce;none).
finna_value(good;poor).
safety_value(safe;unsafe).
access_value(open;restricted).
distance_value(near;far).

season_value(wet;dry;drought).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. LANDSCAPE ASSIGNMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dedha 1
landscape(d1,a,baada). landscape(d1,b,baada). landscape(d1,c,baada).
landscape(d1,d,malbe). landscape(d1,e,malbe). landscape(d1,f,malbe).
landscape(d1,g,wayam). landscape(d1,h,wayam). landscape(d1,i,wayam).

% Dedha 2
landscape(d2,a,caafa). landscape(d2,b,caafa). landscape(d2,c,caafa).
landscape(d2,d,malbe). landscape(d2,e,malbe). landscape(d2,f,malbe).
landscape(d2,g,omar).  landscape(d2,h,omar).  landscape(d2,i,omar).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. LANDSCAPE SEASONAL SUITABILITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suitable_in_season(baada, drought).
suitable_in_season(caafa, drought).

suitable_in_season(malbe, dry).

suitable_in_season(wayam, wet).
suitable_in_season(omar, wet).

seasonally_suitable(D,Z) :-
    landscape(D,Z,L),
    season(S),
    suitable_in_season(L,S).

drought_landscape(D,Z) :-
    landscape(D,Z,L),
    suitable_in_season(L,drought).

dry_landscape(D,Z) :-
    landscape(D,Z,L),
    suitable_in_season(L,dry).

wet_landscape(D,Z) :-
    landscape(D,Z,L),
    suitable_in_season(L,wet).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. TYPE INTEGRITY CONSTRAINTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- current(D,Z), not area(D,Z).
:- destination(D,Z), not area(D,Z).

:- landscape(D,Z,L), not area(D,Z).
:- landscape(D,Z,L), not landscape_type(L).

:- forage(D,Z,F), not area(D,Z).
:- forage(D,Z,F), not forage_value(F).

:- water(D,Z,W), not area(D,Z).
:- water(D,Z,W), not water_value(W).

:- finna(D,Z,V), not area(D,Z).
:- finna(D,Z,V), not finna_value(V).

:- safety(D,Z,S), not area(D,Z).
:- safety(D,Z,S), not safety_value(S).

:- access(D,Z,A), not area(D,Z).
:- access(D,Z,A), not access_value(A).

:- distance_to_water(D,Z,Dist), not area(D,Z).
:- distance_to_water(D,Z,Dist), not distance_value(Dist).

:- seasonal_reserve(D,Z), not area(D,Z).
:- protected(D,Z), not area(D,Z).

:- recent_rain(D,Z), not area(D,Z).
:- heavy_rain(D,Z), not area(D,Z).

:- season(S), not season_value(S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. FUNCTIONAL UNIQUENESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- forage(D,Z,F1), forage(D,Z,F2), F1 != F2.
:- water(D,Z,W1), water(D,Z,W2), W1 != W2.
:- finna(D,Z,V1), finna(D,Z,V2), V1 != V2.
:- safety(D,Z,S1), safety(D,Z,S2), S1 != S2.
:- access(D,Z,A1), access(D,Z,A2), A1 != A2.
:- distance_to_water(D,Z,D1), distance_to_water(D,Z,D2), D1 != D2.
:- landscape(D,Z,L1), landscape(D,Z,L2), L1 != L2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7. DERIVED BOOLEAN VIEWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Water
has_water(D,Z) :- water(D,Z, available).
scarce_water(D,Z) :- water(D,Z, scarce).
no_water(D,Z) :- water(D,Z, none).

% Forage
good_forage(D,Z) :- forage(D,Z, good).
moderate_forage(D,Z) :- forage(D,Z, moderate).
poor_forage(D,Z) :- forage(D,Z, poor).

% Finna
supports_finna(D,Z) :- finna(D,Z, good).
poor_finna(D,Z) :- finna(D,Z, poor).

% Safety
safe_zone(D,Z) :- safety(D,Z, safe).
unsafe_zone(D,Z) :- safety(D,Z, unsafe).

% Access
institutionally_open(D,Z) :- access(D,Z, open).
restricted_zone(D,Z) :- access(D,Z, restricted).

% Distance to water
near_water(D,Z) :- distance_to_water(D,Z, near).
far_water(D,Z) :- distance_to_water(D,Z, far).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8. CONTEXT LAYER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drought_ctx :- season(drought).

effective_rain(D,Z) :-
    season(wet),
    recent_rain(D,Z).

effective_rain(D,Z) :-
    season(dry),
    heavy_rain(D,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9. ROUTE NETWORK WITHIN EACH DEDHA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

route(D,a,b) :- dedha(D).
route(D,b,c) :- dedha(D).

route(D,f,e) :- dedha(D).
route(D,e,d) :- dedha(D).

route(D,g,h) :- dedha(D).
route(D,h,i) :- dedha(D).

route(D,a,f) :- dedha(D).
route(D,f,g) :- dedha(D).

route(D,b,e) :- dedha(D).
route(D,e,h) :- dedha(D).

route(D,c,d) :- dedha(D).
route(D,d,i) :- dedha(D).

% Symmetry
route(D,Y,X) :- route(D,X,Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 10. BLOCKED ROUTE HANDLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% blocked_route(D,X,Y).   % scenario-specific facts

:- blocked_route(D,X,Y), not route(D,X,Y).

usable_route(D,X,Y) :-
    route(D,X,Y),
    not blocked_route(D,X,Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 11. PATH / REACHABILITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path(D,X,Y) :-
    usable_route(D,X,Y).

path(D,X,Z) :-
    path(D,X,Y),
    usable_route(D,Y,Z),
    X != Z.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 12. QUALITATIVE ROUTE-STEP DISTANCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

step_distance(D,X,Y,1) :-
    usable_route(D,X,Y).

step_distance(D,X,Z,N+1) :-
    step_distance(D,X,Y,N),
    usable_route(D,Y,Z),
    X != Z,
    N < 10.

near_route(D,X,Y) :-
    step_distance(D,X,Y,1).

near_route(D,X,Y) :-
    step_distance(D,X,Y,2).

far_route(D,X,Y) :-
    path(D,X,Y),
    not near_route(D,X,Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 13. PHYSICAL REACHABILITY STATUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

physically_reachable(D,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    path(D,Zc,Zd).

unreachable(D,Zd) :-
    current(D,Zc),
    destination(D,Zd),
    not path(D,Zc,Zd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 14. OPTIONAL LANDSCAPE VIEWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_baada(D,Z) :- landscape(D,Z,baada).
is_caafa(D,Z) :- landscape(D,Z,caafa).
is_malbe(D,Z) :- landscape(D,Z,malbe).
is_wayam(D,Z) :- landscape(D,Z,wayam).
is_omar(D,Z)  :- landscape(D,Z,omar).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 15. SANITY CONSTRAINTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Unique current location
:- current(D1,Z1), current(D2,Z2), (D1,Z1) != (D2,Z2).

% Current and destination cannot be the same
:- current(D,Z), destination(D,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 16. OUTPUT CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show current/2.
#show destination/2.

#show landscape/3.
#show seasonally_suitable/2.

#show route/3.
#show blocked_route/3.
#show usable_route/3.
#show path/3.

#show physically_reachable/2.
#show unreachable/2.

#show near_route/3.
#show far_route/3.

#show has_water/2.
#show good_forage/2.
#show moderate_forage/2.
#show poor_forage/2.
#show supports_finna/2.
#show poor_finna/2.
#show unsafe_zone/2.
#show restricted_zone/2.
#show institutionally_open/2.
#show effective_rain/2.
