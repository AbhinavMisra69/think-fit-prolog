% ======================================================================
% FITSPHERE: CLASSICAL AI EXPERT SYSTEM
% ======================================================================

:- dynamic user_memory/2. % Stores temporary session data
:- consult('knowledge_base.pl').

% ======================================================================
% KNOWLEDGE BASE 
% phase_params(PhaseName, DefaultSets, MinReps, MaxReps, ProgressionStyle).
% ======================================================================
% 1. MACROCYCLE PROGRESSIONS
% Format: macrocycle(Goal, Duration, [phase(PhaseName, BaseWeeks)...]).
% ----------------------------------------------------------------------
macrocycle(recomposition, '2_months', [phase(strength_foundation, 3), phase(recomposition, 5)]).
macrocycle(recomposition, '4_months', [phase(strength_foundation, 5), phase(recomposition_1, 5), phase(recomposition_2, 4), phase(peak_recomposition, 2)]).

macrocycle(build_muscle, '2_months', [phase(foundation_hypertrophy, 4), phase(volume_surge, 4)]).
macrocycle(build_muscle, '4_months', [phase(foundation_hypertrophy, 4), phase(volume_surge, 5), phase(strength_block, 4), phase(peak_volume, 3)]).

macrocycle(lose_fat, '2_months', [phase(foundation, 3), phase(build_and_burn, 5)]).
macrocycle(lose_fat, '4_months', [phase(foundation, 4), phase(build_and_burn, 6), phase(intensify, 4), phase(metabolic_conditioning, 2)]).

macrocycle(general_health, '2_months', [phase(foundation, 3), phase(active_lifestyle, 5)]).
macrocycle(general_health, '4_months', [phase(foundation, 4), phase(active_lifestyle, 6), phase(endurance_and_strength, 4), phase(sustain, 2)]).


% ----------------------------------------------------------------------
% 2. PHASE UI METADATA
% Format: phase_ui(PhaseID, Name, Focus, ThemeColor).
% ----------------------------------------------------------------------
phase_ui(strength_foundation, 'Strength Foundation', 'Establishing core strength, movement proficiency, and joint integrity.', blue).
phase_ui(recomposition, 'Body Recomposition', 'Simultaneous fat loss and muscle gain through moderate volume.', orange).
phase_ui(recomposition_1, 'Recomposition Block I', 'Initial phase of simultaneous fat loss and muscle gain.', orange).
phase_ui(recomposition_2, 'Recomposition Block II', 'Increasing volume to push past early adaptation plateaus.', emerald).
phase_ui(peak_recomposition, 'Peak Recomposition', 'Maximal effort to finalize body composition shifts.', purple).

phase_ui(foundation_hypertrophy, 'Foundation Hypertrophy', 'Building initial muscle mass and work capacity.', blue).
phase_ui(volume_surge, 'Volume Surge', 'Pushing boundaries with high-volume muscle building.', orange).
phase_ui(strength_block, 'Strength Block', 'Converting new muscle into maximal force production.', emerald).
phase_ui(peak_volume, 'Peak Volume', 'Maximizing muscular fatigue for ultimate growth.', purple).

phase_ui(foundation, 'Foundation', 'Building base conditioning and movement mechanics.', blue).
phase_ui(build_and_burn, 'Build & Burn', 'Simultaneous fat oxidation and muscle retention.', orange).
phase_ui(intensify, 'Intensification', 'Elevating heart rate and caloric expenditure.', emerald).
phase_ui(metabolic_conditioning, 'Metabolic Conditioning', 'Maximizing fat loss through high-intensity efforts.', purple).

phase_ui(active_lifestyle, 'Active Lifestyle', 'Enhancing daily energy levels and functional fitness.', orange).
phase_ui(endurance_and_strength, 'Endurance & Strength', 'Building cardiovascular health and skeletal resilience.', emerald).
phase_ui(sustain, 'Sustain & Maintain', 'Solidifying healthy habits for long-term well-being.', purple).


% ----------------------------------------------------------------------
% 3. BLUEPRINT LIBRARY
% Format: blueprint(SplitName, DayName, [req(Pattern, Amount)...]).
% ----------------------------------------------------------------------
% Full Body
blueprint(full_body, full_body_A, [req(unilateral_leg, 1), req(horizontal_press, 1), req(vertical_pull, 1), req(side_delt_isolation, 1), req(core_stabilization, 1)]).
blueprint(full_body, full_body_B, [req(squat_pattern, 1), req(horizontal_press, 1), req(horizontal_pull, 1), req(bicep_isolation, 1), req(core_stabilization, 1)]).
blueprint(full_body, full_body_C, [req(hinge_pattern, 1), req(vertical_press, 1), req(vertical_pull, 1), req(tricep_isolation, 1), req(core_stabilization, 1)]).

% Upper / Lower
blueprint(upper_lower, upper_day_A, [req(horizontal_press, 1), req(vertical_pull, 1), req(vertical_press, 1), req(horizontal_pull, 1), req(chest_isolation, 1), req(bicep_isolation, 1), req(tricep_isolation, 1)]).
blueprint(upper_lower, lower_day_A, [req(squat_pattern, 1), req(hinge_pattern, 1), req(unilateral_leg, 1), req(quad_isolation, 1), req(glute_isolation, 1), req(core_stabilization, 1)]).
blueprint(upper_lower, upper_day_B, [req(horizontal_press, 1), req(vertical_pull, 1), req(vertical_press, 1), req(horizontal_pull, 1), req(side_delt_isolation, 1), req(bicep_isolation, 1), req(tricep_isolation, 1)]).
blueprint(upper_lower, lower_day_B, [req(squat_pattern, 1), req(hinge_pattern, 1), req(unilateral_leg, 1), req(quad_isolation, 1), req(glute_isolation, 1), req(calf_isolation, 1)]).

% Push / Pull / Legs
blueprint(push_pull_legs, push_day, [req(horizontal_press, 2), req(vertical_press, 1), req(chest_isolation, 1), req(side_delt_isolation, 1), req(tricep_isolation, 2)]).
blueprint(push_pull_legs, pull_day, [req(vertical_pull, 2), req(horizontal_pull, 1), req(rear_delt_isolation, 1), req(bicep_isolation, 2)]).
blueprint(push_pull_legs, leg_day, [req(squat_pattern, 1), req(hinge_pattern, 1), req(unilateral_leg, 1), req(quad_isolation, 1), req(glute_isolation, 1)]).


% ----------------------------------------------------------------------
% 4. PHASE PARAMETERS
% Format: phase_params(Phase, RecSplit, Freq, CompSets, CompReps, IsoSets, IsoReps, RestSecs, Style).
% Note: If Python used 'default_sets', we apply it to both Compound and Isolation here.
% ----------------------------------------------------------------------
% Foundation & Health Arc
phase_params(foundation, full_body, 3, 3, '10-12', 3, '10-12', 90, form_mastery).
phase_params(strength_foundation, full_body, 3, 4, '8-12', 4, '8-12', 120, barbell_linear).
phase_params(active_lifestyle, full_body, 3, 3, '10-12', 3, '10-12', 90, double_progression).

% Recomposition Arc
phase_params(recomposition_1, upper_lower, 4, 4, '8-12', 3, '12-15', 75, recomp_fat_loss_bias).
phase_params(recomposition_2, push_pull_legs, 5, 4, '6-10', 4, '10-12', 90, recomp_muscle_bias).

% Muscle Building Arc
phase_params(hypertrophy_volume, upper_lower, 4, 4, '8-12', 3, '12-15', 90, volume_accumulation).
phase_params(strength_block, push_pull_legs, 5, 5, '5-8', 5, '5-8', 180, heavy_strength_linear).

% Fat Loss Arc (using 'amrap' and 'timed' for metabolic phases)
phase_params(build_and_burn, full_body_circuit, 4, 4, '8-12', 4, '8-12', 45, double_progression).
phase_params(peak_metabolic, mixed_modal_circuit, 4, amrap, 'timed_45_seconds', amrap, 'timed_45_seconds', 30, circuit_style).
% ---------------------------------------------------------
% THE MUSCLE BUILDING ARC (Now fully matching the macrocycle!)
% ---------------------------------------------------------
phase_params(foundation_hypertrophy, upper_lower, 4, 3, '8-10', 3, '10-12', 90, form_mastery).
phase_params(volume_surge, upper_lower, 4, 4, '8-12', 3, '12-15', 90, volume_accumulation).
phase_params(strength_block, push_pull_legs, 5, 5, '5-8', 5, '5-8', 180, heavy_strength_linear).
phase_params(peak_volume, push_pull_legs, 6, 4, '10-15', 4, '15-20', 60, volume_accumulation).

% macrocycle(Goal, [phase(Name, DefaultWeeks)]).
macrocycle(recomposition, [phase(foundation, 4), phase(hypertrophy, 8), phase(strength, 4)]).

% ======================================================================
% INFERENCE ENGINE 1: PROGRESSIVE OVERLOAD 
% (Lab 4 & 8: Rule-Based Expert System using Backward Chaining)
% progressive_overload(Style, LastSets, LastReps, LastWeight, MinReps, MaxReps, NextSets, NextReps, NextWeight)
% ======================================================================

% Rule 1: Double Progression - Hit ceiling (Increase weight, drop reps)
progressive_overload(double_progression, Sets, Reps, Weight, MinReps, MaxReps, Sets, MinReps, NewWeight) :-
    Reps >= MaxReps,
    NewWeight is Weight + 5, !. % Cut operator (!) prevents backtracking if rule succeeds

% Rule 2: Double Progression - Below ceiling (Increase reps, hold weight)
progressive_overload(double_progression, Sets, Reps, Weight, _, MaxReps, Sets, NewReps, Weight) :-
    Reps < MaxReps,
    NewReps is Reps + 1, !.

% Rule 3: Linear Progression - Hit minimum reps (Increase weight)
progressive_overload(linear, Sets, Reps, Weight, MinReps, _, Sets, MinReps, NewWeight) :-
    Reps >= MinReps,
    NewWeight is Weight + 5, !.

% Rule 4: Volume Accumulation - Below set ceiling (Add a set)
progressive_overload(volume, Sets, Reps, Weight, _, _, NewSets, Reps, Weight) :-
    Sets < 5,
    NewSets is Sets + 1, !.

% Fallback Rule: If no conditions met, hold current state.
progressive_overload(_, Sets, Reps, Weight, _, _, Sets, Reps, Weight).

% ======================================================================
% INFERENCE ENGINE 2: DETRAINING DIAGNOSTICS
% (Lab 8: Expert System Decision Tree)
% ======================================================================

% Rule: Less than 2 weeks off -> No change
detraining_diagnosis(WeeksOff, CurrentPhase, _, CurrentPhase) :- 
    WeeksOff < 2, !.

% Rule: 2 to 4 weeks off -> Drop back 1 phase
detraining_diagnosis(WeeksOff, CurrentPhase, Goal, PrevPhase) :- 
    WeeksOff >= 2, WeeksOff =< 4,
    macrocycle(Goal, Phases),
    find_previous_phase(CurrentPhase, 1, Phases, PrevPhase), !.

% Rule: > 4 weeks off -> Drop back 2 phases (Severe detraining)
detraining_diagnosis(WeeksOff, CurrentPhase, Goal, PrevPhase) :- 
    WeeksOff > 4,
    macrocycle(Goal, Phases),
    find_previous_phase(CurrentPhase, 2, Phases, PrevPhase), !.

% Helper: List traversal to find previous phases
find_previous_phase(Current, 1, [phase(Prev, _), phase(Current, _)|_], Prev) :- !.
find_previous_phase(Current, 2, [phase(PrevPrev, _), phase(_, _), phase(Current, _)|_], PrevPrev) :- !.
find_previous_phase(_, _, [phase(First, _)|_], First). % Fallback to foundation

% ======================================================================
% SEARCH ALGORITHM: TIMELINE GENERATION
% (Lab 3 & 5: State Space Search & Uninformed DFS)
% Goal: Find a combination of phase lengths that sum to TargetWeeks, 
% where no phase is less than 3 weeks or greater than 8 weeks.
% ======================================================================

sum_weeks([], 0).
sum_weeks([phase(_, W)|T], Total) :- 
    sum_weeks(T, Rest), 
    Total is W + Rest.

% DFS Generate and Test Algorithm
search_valid_timeline([], []).
search_valid_timeline([phase(Name, _)|T], [phase(Name, W)|FT]) :-
    between(3, 8, W), % Heuristically bounds the search space (Lab 3: Branch & Bound concept)
    search_valid_timeline(T, FT).

generate_custom_timeline(Goal, TargetWeeks, FinalTimeline) :-
    TargetWeeks >= 6, % Constraint verification
    macrocycle(Goal, BaseTimeline),
    % Prolog will automatically backtrack here until sum_weeks = TargetWeeks
    search_valid_timeline(BaseTimeline, FinalTimeline),
    sum_weeks(FinalTimeline, TargetWeeks), !.

% ======================================================================
% COMMAND LINE INTERFACE (Main Program)
% ======================================================================

% Helper to print lists cleanly
print_timeline([]).
print_timeline([phase(N, W)|T]) :-
    write('- '), write(N), write(' Phase: '), write(W), write(' weeks'), nl,
    print_timeline(T).

% ======================================================================
% KNOWLEDGE BASE (Lab 8: Representing Domain Knowledge)
% We replace Python dictionaries with Prolog facts for instant O(1) querying.
% ======================================================================

% Tier Weights for get_highest_tier_score
tier_weight('S_Plus', 5).
tier_weight('S_Tier', 4).
tier_weight('A_Tier', 3).
tier_weight('B_Tier', 2).
tier_weight(_, 1). % Fallback for undefined tiers

% Day Mapping for check_consecutive_days
day_index('Monday', 0).
day_index('Tuesday', 1).
day_index('Wednesday', 2).
day_index('Thursday', 3).
day_index('Friday', 4).
day_index('Saturday', 5).
day_index('Sunday', 6).
% ======================================================================
% BLUEPRINT SEQUENCES (Translating Python split_sequences)
% ======================================================================
blueprint_seq(full_body, [full_body_A, full_body_B, full_body_C]).
blueprint_seq(upper_lower, [upper_day_A, lower_day_A]).
blueprint_seq(push_pull_legs, [push_day, pull_day, leg_day]).
blueprint_seq(push_pull_full, [push_day, pull_day, full_body_A]).
blueprint_seq(upper_lower_full, [upper_day_A, lower_day_A, full_body_A]).
blueprint_seq(upperA_lowerA_upperB_lowerB, [upper_day_A, lower_day_A, upper_day_B, lower_day_B]).
blueprint_seq(push_pull_repeated, [push_day, pull_day]).
blueprint_seq(upperA_lowerA_upperB_lowerB_full, [upper_day_A, lower_day_A, upper_day_B, lower_day_B, full_body_A]).
blueprint_seq(push_pull_legs_upper_lower, [push_day, pull_day, leg_day, upper_day_A, lower_day_A]). % PHAT training
blueprint_seq(push_pull_legs_repeated, [push_day, pull_day, leg_day]).

% Injury Stress Mapping (for W2 Rule)
injury_stress(lower_back, spinal_compression).
injury_stress(lower_back, lumbar_shear).
injury_stress(knee, extreme_knee_torque).
injury_stress(knee, high_knee_torque).
injury_stress(knee, knee_torque).
injury_stress(knee, knees).
injury_stress(lower_back, lower_back).
injury_stress(shoulder, shoulder_impingement).

% Maps the users primary goal to their initial training phase
starting_phase(build_muscle, foundation_hypertrophy).
starting_phase(lose_fat, foundation).
starting_phase(recomposition, strength_foundation).
starting_phase(general_health, foundation).
% Fallback if something weird is entered
starting_phase(_, foundation).

% ======================================================================
% PHASE TRANSLATION DICTIONARY (Internal State -> JSON Tags) W8
% ======================================================================

% Foundation Arc
phase_alias(foundation, foundation).
phase_alias(strength_foundation, foundation).
phase_alias(active_lifestyle, foundation).

% Recomposition Arc
phase_alias(recomposition_1, recomposition).
phase_alias(recomposition_1, recomposition_1).
phase_alias(recomposition_2, recomposition).
phase_alias(recomposition_2, recomposition_2).

% Muscle Building Arc (The ones that were missing!)
phase_alias(foundation_hypertrophy, foundation).
phase_alias(foundation_hypertrophy, hypertrophy_volume).
phase_alias(volume_surge, hypertrophy_volume).    % <--- This will save your current test!
phase_alias(peak_volume, hypertrophy_volume).
phase_alias(strength_block, strength_block).

% Fat Loss Arc
phase_alias(build_and_burn, build_and_burn).
phase_alias(peak_metabolic, peak_metabolic).

% ======================================================================
% 1. HIGHEST TIER SCORE (Heuristic Evaluation)
% Maps a list of tier strings to their numeric weights and finds the max.
% ======================================================================
get_highest_tier_score([], 0).
get_highest_tier_score([Tier|Rest], MaxScore) :-
    tier_weight(Tier, Score1),
    get_highest_tier_score(Rest, Score2),
    MaxScore is max(Score1, Score2).


% ======================================================================
% 2. CONSECUTIVE DAYS CHECK (Lab 5: Search & Constraint Satisfaction)
% Checks for CNS burnout by looking for 3 consecutive days.
% ======================================================================
check_consecutive_days(DaysList) :-
    maplist(day_index, DaysList, Indices),
    sort(Indices, SortedIndices), % Prolog sort removes duplicates and orders
    ( has_three_in_a_row(SortedIndices) ; check_weekend_wrap(SortedIndices) ), !.

% Recursive check for X, X+1, X+2
has_three_in_a_row([A, B, C | _]) :-
    B =:= A + 1, C =:= A + 2, !.
has_three_in_a_row([_ | T]) :-
    has_three_in_a_row(T).

% Hardcoded wrap-around check (Saturday, Sunday, Monday)
check_weekend_wrap(Sorted) :-
    member(5, Sorted), member(6, Sorted), member(0, Sorted).


% ======================================================================
% 3. DETERMINE WEEKLY SPLIT (Lab 6: Rule-based Expert System / Forward Chaining)
% Intelligently adapts splits based on the number of days available.
% Format: determine_split(+BaseSplit, +DaysCount, -FinalSplit, -SystemWarning).
% ======================================================================

% Full Body Overrides
determine_split(full_body, Days, full_body, none) :- Days =< 3, !.
determine_split(full_body, 4, upperA_lowerA_upperB_lowerB, 'Upgraded Full Body (4 days) to Upper/Lower to prevent burnout.').
determine_split(full_body, 5, push_pull_legs_upper_lower, 'Upgraded Full Body (5 days) to 5-Day PPL/UL hybrid.').
determine_split(full_body, Days, push_pull_legs_repeated, 'Upgraded Full Body (6+ days) to PPLx2.') :- Days >= 6.

% Upper/Lower Overrides
determine_split(upper_lower, Days, full_body, 'Temporarily switched 2 days to Full Body to hit muscles twice.') :- Days =< 2, !.
determine_split(upper_lower, 3, upper_lower_full, none).
determine_split(upper_lower, 4, upperA_lowerA_upperB_lowerB, none).
determine_split(upper_lower, 5, upperA_lowerA_upperB_lowerB_full, none).
determine_split(upper_lower, Days, upperA_lowerA_upperB_lowerB, none) :- Days >= 6.

% Push/Pull/Legs Overrides
determine_split(push_pull_legs, Days, full_body, 'Temporarily switched 2 days to Full Body.') :- Days =< 2, !.
determine_split(push_pull_legs, 3, push_pull_full, 'Upgraded PPL (3 days) to Push/Pull/Full to double growth stimulus.').
determine_split(push_pull_legs, 4, push_pull_repeated, none).
determine_split(push_pull_legs, 5, push_pull_legs_upper_lower, none).
determine_split(push_pull_legs, Days, push_pull_legs_repeated, none) :- Days >= 6.

% Fallback Rule
determine_split(_, _, full_body, 'Fallback safety activated.').


% ======================================================================
% 4. SCHEDULE WEEKLY BLUEPRINTS (State Representation)
% Maps days to blueprints using Modulo arithmetic for an infinite rolling queue.
% ======================================================================


% Main Wrapper: Checks if split changed, gets sequence, and rolls the queue
schedule_weekly_blueprints(DaysList, AssignedSplit, LastAssignedSplit, SavedIndex, Calendar, NewIndex) :-
    % 1. Reset index to 0 if the assigned split changed from last week
    ( AssignedSplit \= LastAssignedSplit -> StartIndex = 0 ; StartIndex = SavedIndex ),
    
    % 2. Look up the sequence (safe fallback to full_body)
    ( blueprint_seq(AssignedSplit, Seq) -> true ; blueprint_seq(full_body, Seq) ),
    
    % 3. Recursively map the days using Modulo math
    assign_days(DaysList, Seq, StartIndex, Calendar),
    
    % 4. Calculate the final index for next week
    length(DaysList, Count),
    NewIndex is StartIndex + Count.

% Recursive loop to assign days using modulo arithmetic
assign_days([], _, _, []).
assign_days([Day | RestDays], Seq, Index, [day(Day, DayType) | RestCal]) :-
    length(Seq, SeqLen),
    ModIndex is Index mod SeqLen,
    nth0(ModIndex, Seq, DayType), % Retrieves the item at the modulo index
    NextIndex is Index + 1,
    assign_days(RestDays, Seq, NextIndex, RestCal).


% ======================================================================
% 5. ELIMINATION FILTERS (Lab 5 & 8: Inference Mechanisms & Resolution Refutation)
% Since Prolog doesnt loop through dictionaries, we use `findall/3` to 
% query exercises that satisfy our logical constraints.
% ======================================================================

% W1: Equipment Check
has_equipment(UserTier, UserTools, ReqTier, ReqTools) :-
    UserTier >= ReqTier,
    ( UserTier >= 3 ; member(all, UserTools) ; subset(ReqTools, UserTools) ).

% Returns a list of safe exercises based on equipment
filter_w1_equipment(UserTier, UserTools, SafeExercises) :-
    findall(ExName, 
        (exercise_kb(_, ExName, ReqTier, ReqTools, _, _, _, _, _, _, _, _, _, _),
         has_equipment(UserTier, UserTools, ReqTier, ReqTools)), 
        SafeExercises).

% W2: Injury Check
is_safe_from_injuries(ExName, UserInjuries) :-
    exercise_kb(_, ExName, _, _, ExerciseStressList, _, _, _, _, _, _, _, _, _),
    % It is safe IF there is no overlap between the user's injuries and the exercise's stress
    \+ (member(Injury, UserInjuries), injury_stress(Injury, StressTag), member(StressTag, ExerciseStressList)).


filter_w2_injuries(InputExercises, UserInjuries, SafeExercises) :-
    include({UserInjuries}/[Ex]>>is_safe_from_injuries(Ex, UserInjuries), InputExercises, SafeExercises).

% W8: Phase Matcher (Now fully alias-aware)
is_valid_phase(ExName, CurrentPhase) :-
    exercise_kb(_, ExName, _, _, _, _, AllowedPhases, _, _, _, _, _, _, _),
    ( member(all, AllowedPhases) 
    ; member(CurrentPhase, AllowedPhases)
    ; (phase_alias(CurrentPhase, Alias), member(Alias, AllowedPhases)) 
    ).
filter_w8_phase(InputExercises, CurrentPhase, ValidExercises) :-
    include({CurrentPhase}/[Ex]>>is_valid_phase(Ex, CurrentPhase), InputExercises, ValidExercises).

% W3: Prehab Assembly Engine
% Finds up to 2 prehab exercises that match the users injuries.
% W3: Prehab Assembly Engine (Now with 3 arguments!)
% Finds up to 2 prehab exercises that are safe and available in the filtered database.
find_prehab(UserInjuries, SafeDB, FinalRoutine) :-
    findall(ExName,
        (member(ExName, SafeDB), % Ensures we only use equipment-safe exercises
         exercise_kb(_, ExName, _, _, _, PrehabList, _, _, _, _, _, _, _, _),
         member(Inj, UserInjuries),
         member(Inj, PrehabList)),
        AllPrehab),
    list_to_set(AllPrehab, UniquePrehab), % Remove duplicates
    take_up_to_two(UniquePrehab, FinalRoutine).

take_up_to_two([], []).
take_up_to_two([A], [A]).
take_up_to_two([A, B | _], [A, B]).


% ======================================================================
% CLASSICAL AI EXPERT SYSTEM: THE MASTER ORCHESTRATOR
% ======================================================================

% We assume the Knowledge Base contains facts formatted like this:
% exercise_kb(Name, Tier, Tools, Stress, PrehabFor, Phases, Primary, Secondary, Tiers, Pattern).

% ======================================================================
% 1. DYNAMIC HEURISTIC EVALUATION (Lab 5: Informed Search & Heuristics)
% Evaluates how "good" an exercise is at this specific moment in the search.
% Formula: f(n) = BaseTierScore - (PrimaryOverlap * 2) - (SecondaryOverlap * 1)
% ======================================================================

% Helper: Find the intersection length of two lists
intersection_length([], _, 0).
intersection_length([H|T], List2, Len) :-
    member(H, List2), !,
    intersection_length(T, List2, RestLen),
    Len is RestLen + 1.
intersection_length([_|T], List2, Len) :-
    intersection_length(T, List2, Len).

% The Heuristic Function: evaluate_node(+Exercise, +MusclesHitToday, -Score)
evaluate_node(ExerciseName, MusclesHitToday, Score) :-
    % Grab Primary, Secondary, and Tiers
    exercise_kb(_, ExerciseName, _, _, _, _, _, Primary, Secondary, Tiers, _, _, _, _),
    
    get_highest_tier_score(Tiers, BaseScore),
    
    intersection_length(Primary, MusclesHitToday, PrimaryOverlap),
    intersection_length(Secondary, MusclesHitToday, SecondaryOverlap),
    
    Penalty is (PrimaryOverlap * 2) + (SecondaryOverlap * 1),
    Score is BaseScore - Penalty.

% ======================================================================
% 2. BEST-FIRST SEARCH ASSEMBLY (Lab 5 & 8: Informed Search Strategy)
% Greedily selects the best exercises for a given pattern based on the heuristic.
% ======================================================================

% Base Case: Blueprint is empty, routine is finished.
assemble_routine([], _, _, _, _, []) :- !.

% Recursive Step: Process one pattern requirement at a time.
% Blueprint format: [req(horizontal_push, 2), req(vertical_pull, 1)...]
assemble_routine([req(Pattern, Amount) | RestBlueprint], SafeDB, PhaseParams, History, MusclesHitToday, FinalRoutine) :-
    
    % 1. State Space Generation: Find all safe exercises matching the pattern
    findall(Ex, (member(Ex, SafeDB), exercise_kb(_, Ex, _, _, _, _, _, _, _, _, Pattern, _, _, _)), Matching),
    
    % Handle empty matches gracefully
    ( Matching = [] ->
        RoutineNodes = [system_notice('No safe exercises found', Pattern)],
        UpdatedMuscles = MusclesHitToday
    ;
        % 2. Heuristic Scoring
        % Map every matching exercise to a Key-Value pair: Score-Exercise
        findall(Score-Ex, (member(Ex, Matching), evaluate_node(Ex, MusclesHitToday, Score)), ScoredList),
        
        % 3. Best-First Search Selection (Sort by Score, Highest First)
        keysort(ScoredList, Ascending),
        reverse(Ascending, Descending), % Highest scores at the front
        
        % 4. Extract top N nodes based on required Amount
        extract_top_n(Descending, Amount, SelectedExercises),
        
        % 5. Apply Rule-Based Expert System (Progressive Overload) to selections
        build_workout_nodes(SelectedExercises, PhaseParams, History, RoutineNodes, NewMuscles),
        
        % 6. Update the State (Muscles hit today) to penalize future selections
        append(MusclesHitToday, NewMuscles, UpdatedMuscles)
    ),
    
    % 7. Recurse to solve the rest of the blueprint
    assemble_routine(RestBlueprint, SafeDB, PhaseParams, History, UpdatedMuscles, RestRoutine),
    
    % Combine results
    append(RoutineNodes, RestRoutine, FinalRoutine).

% Helper: Extract top N elements
extract_top_n(_, 0, []) :- !.
extract_top_n([], _, []) :- !.
extract_top_n([_-Ex | T], N, [Ex | Rest]) :-
    NextN is N - 1,
    extract_top_n(T, NextN, Rest).


% ======================================================================
% 3. PROGRESSIVE OVERLOAD NODE BUILDER (Lab 4: Inference Engine)
% Translates selected exercises into actionable workout nodes.
% ======================================================================
% ======================================================================
% 3. PROGRESSIVE OVERLOAD NODE BUILDER (Lab 4: Inference Engine)
% Translates selected exercises into actionable workout nodes.
% ======================================================================

build_workout_nodes([], _, _, [], []).
build_workout_nodes([ExName | RestEx], PhaseName, History, [Node | RestNodes], AllPrimaryMuscles) :-
    
    % 1. Extract Exercise Details
    exercise_kb(_, ExName, _, _, _, _, _, PrimaryTargets, _, _, _, IsCompound, Desc, YoutubeID),
    
    % 2. THE FIX: Query the 9-argument phase_params rule!
    phase_params(PhaseName, _Split, _Freq, CompSets, CompRepsStr, IsoSets, IsoRepsStr, _Rest, Style),
    
    % 3. SMART ROUTING: Assign different targets based on exercise type
    ( IsCompound == true 
    -> BaseSets = CompSets, BaseRepsStr = CompRepsStr
    ;  BaseSets = IsoSets,  BaseRepsStr = IsoRepsStr
    ),
    
    % 4. Parse the string (e.g., '8-12') into Min and Max integers for the math engine
    (   split_string(BaseRepsStr, "-", "", [MinStr, MaxStr]),
        number_string(MinR, MinStr), number_string(MaxR, MaxStr)
    ->  true
    ;   MinR = 8, MaxR = 12 % Safe fallback if the phase uses a weird string like 'timed_45_seconds'
    ),
    
    % 5. Apply Progressive Overload Rules (if user has history)
    ( member(hist(ExName, LastSets, LastReps, LastWeight), History) 
    ->  progressive_overload(Style, LastSets, LastReps, LastWeight, MinR, MaxR, NextS, NextR, NextW)
    ;   NextS = BaseSets, NextR = BaseRepsStr, NextW = 'Determine Base'
    ),
    
    % 6. Construct the final output node
    Node = workout_node(ExName, NextS, NextR, NextW, IsCompound, Desc, YoutubeID),
    
    % 7. Recurse and aggregate muscles hit
    build_workout_nodes(RestEx, PhaseName, History, RestNodes, RestMuscles),
    append(PrimaryTargets, RestMuscles, AllPrimaryMuscles).

% ======================================================================
% 4. MASTER ORCHESTRATOR (Lab 3: Problem Reduction)
% Reduces the massive scheduling problem into smaller filter sub-problems.
% ======================================================================

generate_daily_workout(UserMemory, Blueprint, PhaseName, History, FinalWorkout) :-
    
    % Extract user profile from dynamic memory
    member(injuries(UserInjuries), UserMemory),
    member(tier(UserTier), UserMemory),
    member(tools(UserTools), UserMemory),
    
    % 1. Problem Reduction: Apply Successive Elimination Filters
    % (Each step dramatically reduces the search space)
    filter_w1_equipment(UserTier, UserTools, DB_W1),
    filter_w2_injuries(DB_W1, UserInjuries, DB_W2),
    filter_w8_phase(DB_W2, PhaseName, FinalDB),
    
    % 2. Extract Prehab (Rule W3)
    find_prehab(UserInjuries, FinalDB, WarmupRoutine),
    
    % 3. State Modification: Remove prehab exercises from the main pool to prevent duplication
    subtract(FinalDB, WarmupRoutine, MainDB),
    
    % 4. Heuristic Assembly Engine (Rule W6)
    assemble_routine(Blueprint, MainDB, PhaseName, History, [], MainRoutine),
    
    % Combine Prehab and Main Routine into the final plan
    append(WarmupRoutine, MainRoutine, FinalWorkout).

% ======================================================================
% WEEKLY PLAN ORCHESTRATOR (Translating Pythons generate_week)
% ======================================================================

% Main entry point to generate a full 7-day week
generate_week(MemoryList, History, WeeklyPlan) :-
    write('[SYSTEM] Extracting User State from Memory...'), nl,
    
    % 1. Extract Working Memory (Replacing SQL SELECT)
    member(goal(Goal), MemoryList),
    member(schedule(Days), MemoryList),
    member(duration(DurationWeeks), MemoryList),
    member(weeks_in_program(WeekNum), MemoryList),
    
    % 2. Deduce Active Phase (Replacing determine_active_phase)
    write('[SYSTEM] Deducing active macrocycle phase...'), nl,
    macrocycle(Goal, DurationWeeks, PhasesList),
    format('PhasesList : ~w', [PhasesList]), nl,
    find_phase_for_week(WeekNum, PhasesList, ActivePhase),
    format('Active Phase : ~w', [ActivePhase]), nl,

    % 3. Retrieve Phase Parameters and Split Base (With Safe Fallback!)
    ( phase_params(ActivePhase, BaseSplit, _, _, _, _, _, _, _) -> 
        true 
    ; 
        write('! [SYSTEM WARNING] Missing params for '), write(ActivePhase), write('. Using foundation.'), nl,
        phase_params(foundation, BaseSplit, _, _, _, _, _, _, _)
    ),
    format('Base Split : ~w', [BaseSplit]), nl,
    
    
    % NEW: 3.5. Execute Safety Overrides based on Users Schedule!
    length(Days, DaysCount),
    determine_weekly_split(BaseSplit, DaysCount, AssignedSplit, WarningMsg),
    
    % Print the warning if one was triggered
    ( WarningMsg \= none ->
        write('! [ADAPTIVE OVERRIDE TRIGGERED] '), write(WarningMsg), nl
    ; 
        true 
    ),
    
    % 4. Schedule Blueprints (Now using the dynamically AssignedSplit!)
    write('[SYSTEM] Mapping split to user calendar...'), nl,
    
    ( member(last_assigned_split(LastSplit), MemoryList) -> true ; LastSplit = none ),
    ( member(split_rotation_index(SavedIndex), MemoryList) -> true ; SavedIndex = 0 ),
    
    % Notice we pass AssignedSplit here instead of BaseSplit
    schedule_weekly_blueprints(Days, AssignedSplit, LastSplit, SavedIndex, Calendar, NewIndex),


    write('[SYSTEM] Next week will start at sequence index: '), write(NewIndex), nl,
    format('Calendar ~w', [Calendar]), nl,
    
    % 5. Generate Workouts recursively for each day in the calendar
    write('[SYSTEM] Assembling daily blueprints...'), nl,
    generate_workouts_for_calendar(Calendar, BaseSplit, ActivePhase, MemoryList, History, WeeklyPlan).


% Helper to iterate over the calendar and build the days
generate_workouts_for_calendar([], _, _, _, _, []).

% Skip rest days
generate_workouts_for_calendar([day(DayName, rest) | RestCal], AssignedSplit, Phase, Mem, Hist, [rest_day(DayName) | RestPlan]) :-
    generate_workouts_for_calendar(RestCal, AssignedSplit, Phase, Mem, Hist, RestPlan).

% Generate actual workout days
generate_workouts_for_calendar([day(DayName, DayType) | RestCal], AssignedSplit, Phase, Mem, Hist, [workout_day(DayName, DayType, DailyWorkout) | RestPlan]) :-
    

    determine_library_category(DayType, AssignedSplit, Category),
    
    % Fetch the specific blueprint for this day
    blueprint(Category, DayType, Blueprint),
    
    % Run the core AI engine for this specific day
    generate_daily_workout(Mem, Blueprint, Phase, Hist, DailyWorkout),
    
    % Recursively process the rest of the week
    generate_workouts_for_calendar(RestCal, AssignedSplit, Phase, Mem, Hist, RestPlan).


% ======================================================================
% SUPPORTING INFERENCE RULES
% ======================================================================

% ======================================================================
% ADAPTIVE SPLIT ENGINE (Translating Pythons determine_weekly_split)
% ======================================================================

% Helper to identify Full Body variants
is_full_body_variant(full_body).
is_full_body_variant(full_body_circuit).
is_full_body_variant(mixed_modal_circuit).

% 1. Full Body & Circuits Overrides
determine_weekly_split(BaseSplit, DaysCount, BaseSplit, none) :-
    is_full_body_variant(BaseSplit), DaysCount =< 3, !.
determine_weekly_split(BaseSplit, 4, upperA_lowerA_upperB_lowerB, 'Doing Full Body 4 days a week limits recovery. We automatically upgraded you to an Upper/Lower split for optimal growth and joint health.') :-
    is_full_body_variant(BaseSplit), !.
determine_weekly_split(BaseSplit, 5, push_pull_legs_upper_lower, 'Doing Full Body 5+ days a week causes severe central nervous system fatigue. We upgraded you to a 5-Day Push/Pull/Legs/Upper/Lower hybrid.') :-
    is_full_body_variant(BaseSplit), !.
determine_weekly_split(BaseSplit, DaysCount, push_pull_legs_repeated, 'Doing Full Body 6+ days a week causes severe central nervous system fatigue. We upgraded you to a 6-Day Push/Pull/Legs hybrid.') :-
    is_full_body_variant(BaseSplit), DaysCount >= 6, !.

% 2. Adapting Upper/Lower Blocks
determine_weekly_split(upper_lower, DaysCount, full_body, 'This phase is optimized for at least 3 days. To ensure you hit every muscle twice a week, we have temporarily switched your 2 days to Full Body.') :-
    DaysCount =< 2, !.
determine_weekly_split(upper_lower, 3, upper_lower_full, none) :- !.
determine_weekly_split(upper_lower, 4, upperA_lowerA_upperB_lowerB, none) :- !.
determine_weekly_split(upper_lower, 5, upperA_lowerA_upperB_lowerB_full, none) :- !.
determine_weekly_split(upper_lower, DaysCount, upperA_lowerA_upperB_lowerB, none) :-
    DaysCount >= 6, !.

% 3. Adapting Push/Pull/Legs Blocks
determine_weekly_split(push_pull_legs, DaysCount, full_body, 'This phase requires at least 3 days to complete a full Push/Pull/Legs cycle. We temporarily switched your 2 days to Full Body.') :-
    DaysCount =< 2, !.
determine_weekly_split(push_pull_legs, 3, push_pull_full, 'Standard PPL on 3 days only hits muscles once a week. We upgraded your split to Push/Pull/Full Body to double your muscle growth stimulus.') :- !.
determine_weekly_split(push_pull_legs, 4, push_pull_repeated, none) :- !.
determine_weekly_split(push_pull_legs, 5, push_pull_legs_upper_lower, none) :- !.
determine_weekly_split(push_pull_legs, DaysCount, push_pull_legs_repeated, none) :-
    DaysCount >= 6, !.

% Fallback Safety (If something completely unrecognized is passed)
determine_weekly_split(_, _, full_body, none).



% Find which phase a specific week falls into (Mathematical Recursion)
find_phase_for_week(W, [phase(P, BaseW) | _], P) :- 
    W =< BaseW, format('Phase : ~w', [P]),!.
find_phase_for_week(W, [phase(_, BaseW) | Rest], P) :-
    W > BaseW,
    NewW is W - BaseW,
    find_phase_for_week(NewW, Rest, P).

% 🎯 Flexible string matching to find the correct Blueprint Library
determine_library_category(DayType, _, upper_lower) :-
    (sub_atom(DayType, _, _, _, 'upper_day') ; sub_atom(DayType, _, _, _, 'lower_day')), !.

determine_library_category(DayType, _, push_pull_legs) :-
    (sub_atom(DayType, _, _, _, 'push_day') ; sub_atom(DayType, _, _, _, 'pull_day') ; sub_atom(DayType, _, _, _, 'leg_day')), !.

determine_library_category(DayType, _, full_body) :-
    sub_atom(DayType, _, _, _, 'full_body'), !.

determine_library_category(_, AssignedSplit, AssignedSplit). % Fallback

% Mock Scheduler (In a full app, this would dynamically distribute days)
% Here we map a 3-day schedule to Full Body A, B, and C
schedule_weekly_blueprints(['Monday', 'Wednesday', 'Friday'], full_body, 
    [day('Monday', full_body_A), day('Wednesday', full_body_B), day('Friday', full_body_C)]).


% ======================================================================
% THE USER INTERFACE (Main Program Execution)
% ======================================================================

% Mapping symbols to mathematical weights
tier_numeric(home, 1).
tier_numeric(basic_gym, 2).
tier_numeric(pro_gym, 3).
tier_numeric(_, 1). % Fallback to home if the user types a typo

% ======================================================================
% NUMBERED MENU INTERFACES
% ======================================================================

ask_tier(Tier) :-
    write('Select your facility tier:'), nl,
    write('1. Home Gym'), nl,
    write('2. Basic Gym'), nl,
    write('3. Pro Gym'), nl,
    write('> '), read(Choice),
    map_tier(Choice, Tier).

map_tier(1, home).
map_tier(2, basic_gym).
map_tier(3, pro_gym).
map_tier(_, basic_gym). % Fallback

ask_injuries(Injuries) :-
    write('Select known injuries:'), nl,
    write('1. None (Fully Healthy)'), nl,
    write('2. Knee Issues'), nl,
    write('3. Lower Back Issues'), nl,
    write('> '), read(Choice),
    map_injuries(Choice, Injuries).

map_injuries(1, []).
map_injuries(2, [knee]).
map_injuries(3, [lower_back]).
map_injuries(_, []).

ask_equipment(Tools) :-
    write('Select available equipment:'), nl,
    write('1. Bodyweight Only'), nl,
    write('2. Dumbbells & Bench'), nl,
    write('3. Standard Gym (Barbell, Dumbbells, Cables)'), nl,
    write('4. ALL Equipment (God Mode - Unlocks everything)'), nl,
    write('> '), read(Choice),
    map_equipment(Choice, Tools).

map_equipment(1, []).
map_equipment(2, [dumbbells, bench]).
map_equipment(3, [dumbbells, barbell, bench, cable_machine, squat_rack]).
map_equipment(4, [all]).
map_equipment(_, [all]).

ask_goal(Goal) :-
    write('Select your primary fitness goal:'), nl,
    write('1. Build Muscle'), nl,
    write('2. Lose Fat'), nl,
    write('3. Body Recomposition'), nl,
    write('4. General Health'), nl,
    write('> '), read(Choice),
    map_goal(Choice, Goal).

map_goal(1, build_muscle).
map_goal(2, lose_fat).
map_goal(3, recomposition).
map_goal(4, general_health).
map_goal(_, recomposition). % Fallback

% ======================================================================
% THE USER INTERFACE (Main Program Execution)
% ======================================================================

% Helper to clear old memory when starting a new session
clear_session :-
    retractall(user_memory(_)).

% ======================================================================
% THE USER INTERFACE (Main Program Execution)
% ======================================================================

start :-
    clear_session,
    write('======================================================'), nl,
    write('      FITSPHERE: CLASSICAL AI EXPERT SYSTEM           '), nl,
    write('======================================================'), nl, nl,
    
    % 1. Collect User Profile via Menus
    write('--- PROFILE SETUP ---'), nl,
    ask_tier(TierInput),
    tier_numeric(TierInput, TierValue), 
    assertz(user_memory(tier(TierValue))), nl,
    
    ask_injuries(Injuries),
    assertz(user_memory(injuries(Injuries))), nl,
    
    ask_equipment(Tools),
    assertz(user_memory(tools(Tools))), nl,
    
    ask_goal(Goal), nl, % <--- Ask for the Goal instead of the Phase
    
    !, % <--- THE CUT: Stops Prolog from looping back to the menus!
    
    % 2. ONBOARDING INFERENCE: Deduce the Starting Phase
    starting_phase(Goal, Phase),
    
    write('======================================================'), nl,
    write('[SYSTEM] Onboarding Complete.'), nl,
    write('[SYSTEM] Deduced Starting Phase: '), write(Phase), nl,
    write('======================================================'), nl, nl,
    
    % Blueprint for the daily workout (We use a full-body setup as standard onboarding)
    Blueprint = [req(squat_pattern, 1), req(horizontal_push, 1), req(vertical_pull, 1), req(core_stabilization, 1)],
    
    % --- Inside your start. rule ---
    
    % Set up dynamic variables that Python normally pulled from SQL
    assertz(user_memory(goal(Goal))),
    assertz(user_memory(schedule(['Monday', 'Tuesday', 'Thursday', 'Friday']))),
    assertz(user_memory(duration('4_months'))),
    assertz(user_memory(weeks_in_program(6))),
    
    % The variables Python normally pulls from SQL
    assertz(user_memory(last_assigned_split(upper_lower))), 
    assertz(user_memory(split_rotation_index(3))), % Simulating they are deep into the queue
    
    !, % The Cut
    
    % Run the Master Orchestrator for the FULL WEEK
    findall(Mem, user_memory(Mem), MemoryList),
    generate_week(MemoryList, [], WeeklyPlan),
    
    % Print the Results cleanly
    write('>> YOUR OPTIMIZED WEEKLY PLAN <<'), nl,
    print_weekly_plan(WeeklyPlan),
    
    write('======================================================'), nl,
    write('Weekly Program generated successfully.'), nl.

% Helper to print the weekly plan
print_weekly_plan([]).
print_weekly_plan([rest_day(DayName) | Rest]) :-
    write('--- '), write(DayName), write(': REST DAY ---'), nl, nl,
    print_weekly_plan(Rest).
print_weekly_plan([workout_day(DayName, DayType, Workout) | Rest]) :-
    write('--- '), write(DayName), write(' ('), write(DayType), write(') ---'), nl,
    print_workout(Workout), nl,
    print_weekly_plan(Rest).

% Helper to cleanly print the generated nodes
% Helper to cleanly print the generated nodes
print_workout([]).
print_workout([workout_node(Name, Sets, Reps, Weight, IsCompound, Desc, YT) | Rest]) :-
    write('- EXERCISE: '), write(Name), nl,
    write('  Targets: '), write(Sets), write(' sets of '), write(Reps), write(' reps @ '), write(Weight), nl,
    write('  Compound: '), write(IsCompound), nl,
    write('  Details: '), write(Desc), nl, % <-- We are now using the Desc variable!
    write('  Video: https://youtube.com/watch?v='), write(YT), nl,
    write('  -----------------------------------'), nl,
    print_workout(Rest).

% Fallback print for system notices/prehab
print_workout([system_notice(Msg, Pattern) | Rest]) :-
    write('! WARNING: '), write(Msg), write(' ['), write(Pattern), write(']'), nl,
    write('  -----------------------------------'), nl,
    print_workout(Rest).
