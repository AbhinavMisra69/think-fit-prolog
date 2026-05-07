% ======================================================================
% ======================================================================

:- module(thinkfit_nutrition, [
    generate_nutrition_profile/12,
    calculate_bmr/5,
    calculate_tdee/3,
    calculate_optimized_calories/7,
    calculate_macros/7,
    calculate_health_limits/4
]).

% ----------------------------------------------------------------------
% 1. KNOWLEDGE BASE: ACTIVITY MULTIPLIERS
% ----------------------------------------------------------------------
activity_multiplier(sedentary, 1.2).
activity_multiplier(light, 1.375).
activity_multiplier(moderate, 1.55).
activity_multiplier(heavy, 1.725).
activity_multiplier(extreme, 1.9).

% ----------------------------------------------------------------------
% 2. BMR & TDEE ENGINE (Mifflin-St Jeor)
% ----------------------------------------------------------------------
calculate_bmr(Gender, Age, WeightKg, HeightCm, BMR) :-
    Base is (10 * WeightKg) + (6.25 * HeightCm) - (5 * Age),
    ( Gender == male -> BMR is Base + 5 ; BMR is Base - 161 ).

calculate_tdee(BMR, ActivityLevel, TDEE) :-
    ( activity_multiplier(ActivityLevel, Mult) -> true ; Mult = 1.2 ),
    TDEE is BMR * Mult.

% ----------------------------------------------------------------------
% 3. PHASE OPTIMIZATION ENGINE
% Determines Recomp (Cutting) vs. Building based on Body Fat Thresholds
% ----------------------------------------------------------------------
needs_recomp(male, BodyFatPct) :- BodyFatPct >= 20.0, !.
needs_recomp(female, BodyFatPct) :- BodyFatPct >= 30.0, !.

% Rule 1: Body Recomposition (Fat Loss Focus)
calculate_optimized_calories(Gender, WeightKg, BodyFatPct, _, TDEE, TargetCals, recomposition) :-
    needs_recomp(Gender, BodyFatPct), !,
    % Lose max 0.5% bodyweight/week
    KgLossPerWeek is WeightKg * 0.005,
    RawDeficit is (KgLossPerWeek * 7700) / 7,
    % Clamp deficit between 250 and 500
    Deficit is max(250, min(RawDeficit, 500)),
    TargetCals is TDEE - Deficit.

% Rule 2: Muscle Building (Surplus Focus)
calculate_optimized_calories(_, _, _, ExperienceLevel, TDEE, TargetCals, build_muscle) :-
    ( ExperienceLevel == beginner -> Surplus = 400
    ; ExperienceLevel == intermediate -> Surplus = 250
    ; ExperienceLevel == advanced -> Surplus = 150
    ; Surplus = 300 % Fallback
    ),
    TargetCals is TDEE + Surplus.

% ----------------------------------------------------------------------
% 4. DYNAMIC MACRO CALCULATOR
% Adjusts ranges based on the active phase (Recomp vs Build)
% ----------------------------------------------------------------------
calculate_macros(WeightKg, DailyCalories, Phase, ProteinG, CarbsG, FatG, SatFatLimitG) :-
    % 1. Protein Target (1.6g per kg)
    ProteinG is round(WeightKg * 1.6),
    ProteinCals is ProteinG * 4,
    
    % 2. Carbohydrate Target & Clamping
    ( Phase == recomposition ->
        TargetMultiplier = 2.5, LowerBound = 2.5, UpperBound = 4.0
    ; % build_muscle
        TargetMultiplier = 4.0, LowerBound = 4.0, UpperBound = 6.0
    ),
    
    TargetCarbs is WeightKg * TargetMultiplier,
    MinCarbs is WeightKg * LowerBound,
    MaxCarbs is WeightKg * UpperBound,
    
    CarbsG is round(max(MinCarbs, min(TargetCarbs, MaxCarbs))),
    CarbCals is CarbsG * 4,
    
    % 3. Fat Target (Leftover calories, absolute minimum 30g)
    RemainingCals is DailyCalories - (ProteinCals + CarbCals),
    RawFat is RemainingCals / 9,
    FatG is round(max(RawFat, 30)),
    
    % 4. Saturated Fat Internal Limit (Max 30% of total fat)
    SatFatLimitG is round(FatG * 0.3).

% ----------------------------------------------------------------------
% 5. AHA HEALTH LIMITS
% ----------------------------------------------------------------------
calculate_health_limits(Gender, DailyCalories, SatFatMaxG, SugarMaxG) :-
    SatFatCals is DailyCalories * 0.10,
    SatFatMaxG is round(SatFatCals / 9),
    ( Gender == male -> SugarMaxG = 36 ; SugarMaxG = 25 ).

% ----------------------------------------------------------------------
% 6. THE MASTER NUTRITION ORCHESTRATOR
% Executes the full profile generation pipeline.
% ----------------------------------------------------------------------
generate_nutrition_profile(Gender, Age, HeightCm, WeightKg, ActivityLevel, BodyFatPct, ExperienceLevel, 
                           FinalPhase, FinalCals, FinalProt, FinalCarbs, FinalFat) :-
    
    calculate_bmr(Gender, Age, WeightKg, HeightCm, BMR),
    calculate_tdee(BMR, ActivityLevel, TDEE),
    
    calculate_optimized_calories(Gender, WeightKg, BodyFatPct, ExperienceLevel, TDEE, RawCals, FinalPhase),
    FinalCals is round(RawCals),
    
    calculate_macros(WeightKg, FinalCals, FinalPhase, FinalProt, FinalCarbs, FinalFat, _SatFatLimit).