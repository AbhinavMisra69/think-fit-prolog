:- module(thinkfit_server, [start_server/1, stop_server/1]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).
:- use_module(library(csv)).

:- set_setting(http:cors, [*]).

% In-Memory Database
:- dynamic food_item/7.
:- dynamic user_profile/4. % TargetCals, TargetProt, TargetCarbs, TargetFat
:- dynamic daily_log/4.    % CurrentCals, CurrentProt, CurrentCarbs, CurrentFat

% Start Server
start_server(Port) :-
    load_csv_database('../core/indian_food_dataset.csv'),
    (daily_log(_,_,_,_) -> true ; assertz(daily_log(0, 0, 0, 0))),
    http_server(http_dispatch, [port(Port)]).

stop_server(Port) :- http_stop_server(Port, []).

% Load CSV
load_csv_database(Path) :-
    csv_read_file(Path, Rows, [skip_header(row(_,_,_,_,_))]),
    maplist(assert_food_row, Rows).

assert_food_row(row(Name, Cals, Prot, Carb, Fat)) :-
    (number(Cals) -> C=Cals ; C=0), (number(Prot) -> P=Prot ; P=0),
    (number(Carb) -> Cb=Carb ; Cb=0), (number(Fat) -> F=Fat ; F=0),
    downcase_atom(Name, LowerName), atomic_list_concat(Words, ' ', LowerName), atomic_list_concat(Words, '-', Id),
    assertz(food_item(Id, Name, C, P, Cb, F, 100.0)).
assert_food_row(_).

% Routes
:- http_handler(root('api/onboarding'), api_onboarding, [method(post)]).
:- http_handler(root('api/dashboard'), api_dashboard, [method(get)]).
:- http_handler(root('api/search'), api_search, [method(post)]).
:- http_handler(root('api/log'), api_log, [method(post)]).

api_onboarding(Request) :-
    cors_enable, http_read_json_dict(Request, Data),
    % Simple TDEE Math (assuming male, sedentary for rapid setup)
    BMR is (10 * Data.weight) + (6.25 * Data.height) - (5 * Data.age) + 5,
    TCals is round(BMR * 1.2), TProt is round(Data.weight * 2.2),
    TFat is round((TCals * 0.25) / 9), TCarbs is round((TCals - (TProt * 4) - (TFat * 9)) / 4),
    
    retractall(user_profile(_,_,_,_)),
    assertz(user_profile(TCals, TProt, TCarbs, TFat)),
    reply_json_dict(_{status: "success", cals: TCals}).

api_dashboard(Request) :-
    cors_enable,
    (user_profile(TC, TP, TCb, TF) -> true ; TC=0, TP=0, TCb=0, TF=0),
    daily_log(CC, CP, CCb, CF),
    reply_json_dict(_{
        targets: _{cals: TC, prot: TP, carbs: TCb, fat: TF},
        current: _{cals: CC, prot: CP, carbs: CCb, fat: CF}
    }).

api_search(Request) :-
    cors_enable, http_read_json_dict(Request, Data),
    string_lower(Data.query, Q),
    findall(_{id: Id, name: Name, cals: C}, 
        (food_item(Id, Name, C, _, _, _, _), sub_string(Name, _, _, _, Q)), 
        Matches),
    length(Results, 10), append(Results, _, Matches), % Limit to 10
    reply_json_dict(_{results: Results}).

api_log(Request) :-
    cors_enable, http_read_json_dict(Request, Data),
    food_item(Data.id, _, Cals, Prot, Carbs, Fat, Serving),
    Mult is Data.grams / Serving,
    retract(daily_log(OC, OP, OCb, OF)),
    NC is OC + (Cals * Mult), NP is OP + (Prot * Mult),
    NCb is OCb + (Carbs * Mult), NF is OF + (Fat * Mult),
    assertz(daily_log(NC, NP, NCb, NF)),
    reply_json_dict(_{status: "success"}).