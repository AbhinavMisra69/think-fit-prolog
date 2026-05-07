:- use_module(library(csv)).
:- use_module('core/thinkfit_nutrition.pl').
:- consult('thinkfit_expert.pl').

% ---------------------------------------------------------
% DYNAMIC MEMORY
% ---------------------------------------------------------
:- dynamic food_item/7.
:- dynamic daily_macros/4. 
:- dynamic target_macros/4.

% ---------------------------------------------------------
% BOOT SEQUENCE
% ---------------------------------------------------------
cli_start :-
    format('~n======================================================~n'),
    format('          🏋️  THINKFIT TERMINAL OS  🏋️          ~n'),
    format('======================================================~n'),
    load_csv_database,
    (daily_macros(_,_,_,_) -> true ; assertz(daily_macros(0,0,0,0))),
    run_onboarding,
    main_menu.

% ---------------------------------------------------------
% COMPREHENSIVE ONBOARDING 
% ---------------------------------------------------------
run_onboarding :-
    format('~n--- STEP 1: BODY ASSESSMENT ---~n'),
    ask_choice('Gender:', [male, female], Gender),
    ask_num('Age:', Age),
    ask_num('Weight (kg):', Weight),
    ask_num('Height (cm):', Height),
    
    format('~n--- STEP 2: CIRCUMFERENCES (Navy BF% Method) ---~n'),
    ask_num('Neck (cm):', Neck),
    ask_num('Waist (cm):', Waist),
    ask_num('Chest (cm):', _Chest), 
    ask_num('Arm (cm):', _Arm),     
    (Gender == female -> ask_num('Hip (cm):', Hip) ; Hip = 0),
    
    format('~n--- STEP 3: LIFESTYLE & GOALS ---~n'),
    ask_choice('Primary Goal:', [build_muscle, lose_fat, recomposition, general_health], Goal),
    ask_choice('Body Type:', [ectomorph, mesomorph, endomorph, average], _BodyType),
    ask_choice('Daily Activity Level:', [sedentary, light, moderate, heavy], Activity),
    
    format('~n--- STEP 4: EXPERIENCE & SCHEDULE ---~n'),
    ask_choice('Experience Level:', [beginner, intermediate, advanced], Experience),
    ask_choice('Duration:', ['2_months', '4_months'], DurationStr),
    ask_num('Workout Days Per Week (2-7):', DaysPerWeek),
    ask_specific_days(DaysPerWeek, SelectedDays),
    
    format('~n--- STEP 5: MEDICAL & PREFERENCES ---~n'),
    ask_choice('Dietary Preference:', [vegetarian, vegan, non_veg], Diet),
    ask_list('Medical Conditions/Injuries (e.g., lower_back, knee, none):', Injuries),
    
    ask_choice('Workout Location:', [home, basic_gym, pro_gym, outdoor], Location),
    (   Location == pro_gym 
    ->  Tools = [all], format('   -> Pro Gym selected. Assuming all standard equipment is available.~n')
    ;   ask_list('Available Equipment (e.g., dumbbells, barbell, bench, none):', Tools)
    ),

    format('~n⚙️  Processing Biometrics and Calibrating Expert System...~n'),
    sleep(1),
    
    (   Gender == female 
    ->  Diff is Waist + Hip - Neck,
        (Diff =< 0 -> BF = 28.0 ; BF is 495.0 / (1.29579 - 0.35004 * log10(Diff) + 0.22100 * log10(Height)) - 450.0)
    ;   Diff is Waist - Neck,
        (Diff =< 0 -> BF = 15.0 ; BF is 495.0 / (1.0324 - 0.19077 * log10(Diff) + 0.15456 * log10(Height)) - 450.0)
    ),
    BFPct is max(3.0, min(round(BF * 10) / 10, 60.0)),
    
    generate_nutrition_profile(Gender, Age, Height, Weight, Activity, BFPct, Experience, 
                               _PhaseAssigned, TCals, TProt, TCarbs, TFat),
    
    retractall(target_macros(_,_,_,_)),
    assertz(target_macros(TCals, TProt, TCarbs, TFat)),
    
    (Location == home -> TierVal = 1 ; Location == basic_gym -> TierVal = 2 ; TierVal = 3),
    
    retractall(user_memory(_)),
    assertz(user_memory(tier(TierVal))),
    assertz(user_memory(goal(Goal))),
    assertz(user_memory(injuries(Injuries))),
    assertz(user_memory(tools(Tools))),
    assertz(user_memory(schedule(SelectedDays))), 
    assertz(user_memory(duration(DurationStr))),
    assertz(user_memory(diet(Diet))),
    assertz(user_memory(weeks_in_program(1))),
    assertz(user_memory(last_assigned_split(none))),
    assertz(user_memory(split_rotation_index(0))),
    
    format('======================================================~n'),
    format('✅ Calibration Complete!~n'),
    format('   Dietary Mode:       ~w~n', [Diet]),
    format('   Body Fat Est:       ~w%~n', [BFPct]),
    format('   Target Calories:    ~w kcal~n', [TCals]),
    format('======================================================~n').

% ---------------------------------------------------------
% MAIN MENU LOOP
% ---------------------------------------------------------
main_menu :-
    format('~n======================================================~n'),
    print_nutrition_dashboard,
    format('======================================================~n'),
    format('1. Generate AI Weekly Protocol~n'),
    format('2. Log Food (Database Smart Search)~n'),
    format('3. 🤖 AI Meal Recommender (CSP + Heuristic Search)~n'),
    format('4. Recalibrate Profile~n'),
    format('5. Exit~n'),
    ask_string('Choice [1-5]:', Choice),
    handle_choice(Choice).

handle_choice("1") :- generate_terminal_workout, main_menu.
handle_choice("2") :- log_food_menu, main_menu.
handle_choice("3") :- recommend_meal, main_menu.
handle_choice("4") :- run_onboarding, main_menu.
handle_choice("5") :- format('~nShutting down ThinkFit OS. Stay strong! 🦾~n~n'), halt.
handle_choice(_)   :- format('❌ Invalid choice.~n'), main_menu.


% ---------------------------------------------------------
% AI MEAL RECOMMENDER (Goal-Directed CSP & Heuristics)
% ---------------------------------------------------------
recommend_meal :-
    target_macros(TC, TP, _, _),
    daily_macros(CC, CP, _, _),
    RemCals is TC - CC,
    _RemProt is TP - CP, % Underscore fixes singleton warning
    
    user_memory(diet(UserDiet)),
    user_memory(goal(UserGoal)),
    
    format('~n--- 🤖 AI MEAL RECOMMENDER ---~n'),
    ( RemCals < 50 -> format('⚠️ You are completely out of calories for today!~n')
    ; 
      format('Select desired portion size for recommendations:~n'),
      write('  1. Full Meal / Bowl (~250g)'), nl,
      write('  2. Snack / Piece (~50g)'), nl,
      write('  3. Base Serving (100g)'), nl,
      ask_num('Choice [1-3]:', Choice),
      
      ( Choice == 1 -> Mult = 2.5, TypeStr = "BOWLS (~~250g)"
      ; Choice == 2 -> Mult = 0.5, TypeStr = "PIECES / SNACKS (~~50g)"
      ; Choice == 3 -> Mult = 1.0, TypeStr = "STANDARD SERVINGS (100g)"
      ; Mult = 1.0, TypeStr = "STANDARD SERVINGS (100g)"
      ),
      
      format('~n🔍 AI Target: ~w Diet | Goal: ~w | < ~w kcal...~n', [UserDiet, UserGoal, round(RemCals)]),
      sleep(1),
      
      findall(Score-Name-FinalC-FinalP-FinalCb,
          (food_item(_, Name, C100, P100, Cb100, _, _),
           string_lower(Name, LName),
           
           \+ violates_diet(LName, UserDiet), 
           
           RawC is C100 * Mult, 
           RawP is P100 * Mult,
           RawCb is Cb100 * Mult,
           
           RawC > 0, RawC =< RemCals,
           RawP =< (RawC * 0.10), 
           
           FinalC is round(RawC),
           FinalP is round(RawP),
           FinalCb is round(RawCb),
           
           score_meal(UserGoal, FinalC, FinalP, FinalCb, Score)
          ), Matches),
      
      keysort(Matches, Ascending),
      reverse(Ascending, Descending), 
      
      ( Descending == [] 
      -> format('❌ No realistic ~w found that fit your exact macros and diet.~n', [TypeStr])
      ;  format('~n>> TOP 5 RECOMMENDED ~w <<~n', [TypeStr]),
         print_recommendations(Descending, 1, 5)
      )
    ).

score_meal(build_muscle, FinalC, FinalP, _, Score) :-
    FinalP > 10, Score is (FinalP / FinalC) * 1000.

score_meal(recomposition, FinalC, FinalP, FinalCb, Score) :-
    FinalP > 8, MaxCarbs is (FinalC * 0.40) / 4, FinalCb =< MaxCarbs, 
    Score is (FinalP / (FinalCb + 1)) * 1000. 

score_meal(lose_fat, FinalC, _, FinalCb, Score) :-
    MaxCarbs is (FinalC * 0.20) / 4, FinalCb =< MaxCarbs,
    Score is 10000 / (FinalCb + 1).

score_meal(_, FinalC, FinalP, _, Score) :-
    FinalP > 5, Score is (FinalP / FinalC) * 1000.

print_recommendations([], _, _) :- true.
print_recommendations([_-Name-C-P-Cb | Rest], Index, Limit) :-
    Index =< Limit,
    format('  [~w] ~w (~w kcal | ~wg P | ~wg Carbs)~n', [Index, Name, C, P, Cb]),
    Next is Index + 1, print_recommendations(Rest, Next, Limit).
print_recommendations(_, Index, Limit) :- Index > Limit.


% ---------------------------------------------------------
% EXPERT SYSTEM TRIGGER 
% ---------------------------------------------------------
generate_terminal_workout :-
    format('~n--- AI WEEKLY MACROCYCLE GENERATOR ---~n'),
    format('[SYSTEM] Extracting user state from memory...~n'),
    findall(Mem, user_memory(Mem), MemoryList),
    format('[SYSTEM] Initializing Master Orchestrator...~n'),
    generate_week(MemoryList, [], WeeklyPlan),
    format('~n>> YOUR OPTIMIZED WEEKLY PLAN <<~n'),
    print_weekly_plan(WeeklyPlan).

% ---------------------------------------------------------
% DATABASE NUTRITION LOGGER & HYBRID PORTIONS
% ---------------------------------------------------------
print_nutrition_dashboard :-
    target_macros(TC, TP, TCb, _TF), daily_macros(CC, CP, CCb, _CF),
    format(' Cals: ~w / ~w  |  Prot: ~w / ~wg  |  Carbs: ~w / ~wg~n', 
           [round(CC), TC, round(CP), TP, round(CCb), TCb]).

log_food_menu :-
    aggregate_all(count, food_item(_,_,_,_,_,_,_), DBCount),
    (   DBCount == 0 -> format('~n❌ FATAL: Database is empty!~n')
    ;   
        format('~n--- MANUAL DATABASE LOGGER ---~n'),
        ask_string('Search for a food (or type "cancel"):', Query),
        (   Query == "cancel" -> true
        ;   
            string_lower(Query, LowerQ),
            split_string(LowerQ, " ", " ", Keywords),
            
            findall(Len-Id-Name-Cals-Prot, 
                    (food_item(Id, Name, Cals, Prot, _, _, _), 
                     string_lower(Name, LowerName),
                     maplist(contains_keyword(LowerName), Keywords),
                     string_length(Name, Len)), 
                    UnsortedMatches),
            
            keysort(UnsortedMatches, SortedMatches),
            
            (   SortedMatches == [] -> format('❌ No foods found.~n'), log_food_menu
            ;   format('~n--- MATCHES FOUND ---~n'),
                print_matches(SortedMatches, 1, 10),
                format('~n'),
                ask_num('Select the food (or 0 to cancel):', ChoiceNum),
                (   ChoiceNum > 0, ChoiceNum =< 10
                ->  nth1(ChoiceNum, SortedMatches, _Len-SelectedId-SelName-_-_),
                    ask_portion(SelName, Grams),
                    process_food_log(SelectedId, Grams)
                ;   format('Canceled.~n')
                )
            )
        )
    ).

contains_keyword(TargetString, Keyword) :- sub_string(TargetString, _, _, _, Keyword).

print_matches([], _, _).
print_matches([_Len-_Id-Name-Cals-Prot | Rest], Index, Limit) :-
    Index =< Limit, 
    format('  [~w] ~w (~w kcal, ~wg protein / 100g)~n', [Index, Name, round(Cals), round(Prot)]),
    NextIndex is Index + 1, 
    print_matches(Rest, NextIndex, Limit).
print_matches(_, Index, Limit) :- Index > Limit.

ask_portion(Name, Grams) :-
    format('~nHow did you measure the ~w?~n', [Name]),
    write('  1. Grams (Precise)'), nl,
    write('  2. Bowls / Cups (~250g)'), nl,
    write('  3. Pieces / Slices (~50g)'), nl,
    ask_num('Select [1-3]:', Choice),
    ( Choice == 1 -> ask_num('Enter grams:', Grams)
    ; Choice == 2 -> ask_num('Enter number of bowls:', B), Grams is B * 250
    ; Choice == 3 -> ask_num('Enter number of pieces:', P), Grams is P * 50
    ; format('❌ Invalid choice.~n'), ask_portion(Name, Grams)
    ).

process_food_log(FoodId, Grams) :-
    food_item(FoodId, Name, Cals, Prot, Carbs, Fat, Serving),
    Mult is Grams / Serving,
    AddC is Cals * Mult, AddP is Prot * Mult, AddCb is Carbs * Mult, AddF is Fat * Mult,
    
    retract(daily_macros(OC, OP, OCb, OF)),
    NC is OC + AddC, NP is OP + AddP, NCb is OCb + AddCb, NF is OF + AddF,
    assertz(daily_macros(NC, NP, NCb, NF)),
    
    format('~n✅ Successfully logged ~wg of ~w!~n', [round(Grams), Name]),
    format('   Added: ~w kcal | ~wg Protein | ~wg Carbs | ~wg Fat~n', 
           [round(AddC), round(AddP), round(AddCb), round(AddF)]).

% ---------------------------------------------------------
% RULE-BASED DIET FILTERING (Culturally-Aware Knowledge Base)
% ---------------------------------------------------------

violates_diet(Name, vegetarian) :- 
    % Catches standard English meats AND specific Indian culinary terms
    contains_any(Name, [
        "chicken", "mutton", "beef", "pork", "fish", "prawn", "egg", "omelette", 
        "meat", "chops", "boti", "keema", "qeema", "kebab", "kabab", "roghan", 
        "gosht", "murgh", "machli", "seafood", "lamb", "crab", "shrimp"
    ]).

violates_diet(Name, vegan) :- 
    violates_diet(Name, vegetarian). % Vegans also cannot eat anything in the Veg blocklist

violates_diet(Name, vegan) :- 
    % Catches standard English dairy AND Indian dairy/animal byproducts
    contains_any(Name, [
        "paneer", "ghee", "milk", "curd", "butter", "cream", "cheese", "yogurt", 
        "khoya", "mawa", "malai", "honey", "buttermilk", "chaas", "lassi"
    ]).

violates_diet(_, non_veg) :- fail. % Non-vegetarians have no restrictions

contains_any(Str, [K | _]) :- sub_string(Str, _, _, _, K), !.
contains_any(Str, [_ | R]) :- contains_any(Str, R).

% ---------------------------------------------------------
% UTILS & BULLETPROOF CSV LOADER
% ---------------------------------------------------------
ask_string(Prompt, Result) :- format('~w ', [Prompt]), read_line_to_string(user_input, Raw), normalize_space(string(Result), Raw).
ask_num(Prompt, Num) :- ask_string(Prompt, Str), (number_string(N, Str) -> Num = N ; format('❌ Invalid number.~n'), ask_num(Prompt, Num)).

ask_choice(Prompt, Options, Choice) :-
    format('~w~n', [Prompt]), print_options(Options, 1), length(Options, Max),
    format('Select [1-~w]: ', [Max]), read_line_to_string(user_input, Str),
    ( number_string(N, Str), N > 0, N =< Max -> nth1(N, Options, Choice) ; format('❌ Invalid choice.~n'), ask_choice(Prompt, Options, Choice) ).

print_options([], _).
print_options([Opt|Rest], Idx) :- format('  ~w. ~w~n', [Idx, Opt]), Next is Idx + 1, print_options(Rest, Next).

ask_list(Prompt, AtomList) :-
    format('~w ', [Prompt]), read_line_to_string(user_input, Str),
    split_string(Str, ",", " ", StrList),
    ( StrList == [""] -> AtomList = [] ; maplist(atom_string, AtomList, StrList) ).

ask_specific_days(TargetCount, ValidDays) :-
    format('Enter exactly ~w days (e.g., Monday, Wednesday, Friday): ', [TargetCount]),
    read_line_to_string(user_input, Str), split_string(Str, ",", " ", StrList), length(StrList, ActualCount),
    ( ActualCount == TargetCount -> maplist(atom_string, ValidDays, StrList) ; format('❌ You must enter exactly ~w days separated by commas. Try again.~n', [TargetCount]), ask_specific_days(TargetCount, ValidDays) ).

load_csv_database :-
    ( exists_file('core/indian_food_dataset.csv') -> Path = 'core/indian_food_dataset.csv'
    ; exists_file('indian_food_dataset.csv') -> Path = 'indian_food_dataset.csv'
    ; Path = 'none' ),
    ( Path == 'none' -> format('⚠️  WARNING: Could not locate indian_food_dataset.csv.~n')
    ;  format('~n[SYSTEM] Loading food database from ~w...~n', [Path]),
       catch((csv_read_file(Path, Rows, [match_arity(false)]), retractall(food_item(_,_,_,_,_,_,_)), maplist(assert_food_row, Rows), aggregate_all(count, food_item(_,_,_,_,_,_,_), Count), format('✅ Synced ~w database items.~n', [Count])), Error, format('❌ CSV Load Error: ~w~n', [Error]))
    ).

assert_food_row(Row) :-
    Row =.. [row, NameRaw, CalsRaw, CarbRaw, ProtRaw, FatRaw | _],
    format_to_string(NameRaw, Name), Name \= "Dish Name", Name \= "food", Name \= "",
    parse_num(CalsRaw, Cals), parse_num(ProtRaw, Prot), parse_num(CarbRaw, Carb), parse_num(FatRaw, Fat),
    string_lower(Name, LowerName), split_string(LowerName, " ", " ", Words), atomic_list_concat(Words, '-', FoodId),
    assertz(food_item(FoodId, Name, Cals, Prot, Carb, Fat, 100.0)), !.
assert_food_row(_).

format_to_string(V, Str) :- (string(V) -> Str = V ; atom(V) -> atom_string(V, Str) ; term_string(V, Str)).
parse_num(V, Num) :- (number(V) -> Num = V ; (string(V), number_string(N, V)) -> Num = N ; (atom(V), atom_number(V, N)) -> Num = N ; Num = 0.0).