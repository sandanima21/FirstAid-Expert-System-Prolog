/*
   FIRST AID EXPERT SYSTEM - SWI-PROLOG
   ====================================
   Coursework prototype for source-based first-aid guidance.

   USER MODES
   ----------
   1. Quick Advice   - full assessment + all applicable first-aid advice
      Academic mechanism: forward chaining / data-driven reasoning.

   2. Targeted Help  - urgent-care check only
      Academic mechanism: backward chaining / goal-driven reasoning.

   The normal CLI does not show the academic terms above.

   DOMAIN
   ------
   Burn / scald
   Cut / bleeding wound
   Fall
   Adult choking

   SOURCES
   -------
   [S1] NHS - Burns and scalds
        https://www.nhs.uk/conditions/burns-and-scalds/
   [S2] NHS - Cuts and grazes
        https://www.nhs.uk/conditions/cuts-and-grazes/
   [S3] North East Ambulance Service (NHS) - Choking
        https://www.neas.nhs.uk/community-learning/emergency-advice/choking
   [S4] American Red Cross - Head, Neck, and Spinal Injury
        https://production.redcross.org/take-a-class/learn-fa-head-neck-spinal-injury.html
   [S5] American Red Cross - First Aid/CPR/AED Participant's Manual
        https://www.redcross.org/content/dam/redcross/training-services/no-index/First%20Aid-CPR-AED-Participant%27s-Manual.pdf
   [S6] American Red Cross - First Aid Steps
        https://production.redcross.org/take-a-class/first-aid/performing-first-aid/first-aid-steps
   [S7] St John Ambulance - Spinal Injury First Aid
        https://www.sja.org.uk/first-aid-advice/spinal-injury/
   [S8] East of England Ambulance Service - Cuts and grazes
        https://www.eastamb.nhs.uk/your-service/emergency-advice/cuts-and-grazes
   [S9] 1990 Suwa Seriya Foundation
        https://www.1990.lk/faq/

   No domain expert was consulted. The rules below are operational
   representations of statements and warning signs from the sources above.

   IMPORTANT SAFETY NOTE
   ---------------------
   This is an educational prototype. It is not a medical device and does not
   replace professional first-aid/CPR training, clinical assessment, or
   emergency-dispatcher instructions. For a real emergency, contact emergency
   services immediately.
*/

:- dynamic observed/1.
:- dynamic derived/1.
:- dynamic asked/1.

:- use_module(library(ansi_term)).

% ================================================================
% KNOWLEDGE BASE: 34 FACTS
% ================================================================

accident_type(burn).
accident_type(cut).
accident_type(fall).
accident_type(choking).

emergency_service(sri_lanka, '1990 Suwa Seriya').
emergency_number(sri_lanka, '1990').
ambulance_service_scope(sri_lanka, islandwide_free_pre_hospital_emergency_care).

burn_fact(cooling_time_minutes, 20).
burn_fact(cooling_window_hours, 3).
burn_fact(cool_with, cool_running_water).
burn_fact(cover_after_cooling, loose_cling_film).
burn_fact(do_not_use, ice).
burn_fact(do_not_remove, stuck_clothing_or_jewellery).
burn_fact(urgent_sign, large_or_deep).
burn_fact(urgent_sign, face_or_airway_area).

cut_fact(first_action, stop_bleeding).
cut_fact(bleeding_method, direct_pressure).
cut_fact(stuck_object, do_not_remove).
cut_fact(after_bleeding_stops, clean_and_cover).
cut_fact(hygiene, wash_hands_or_use_gloves).
cut_fact(infection_sign, increasing_redness_swelling_pain_or_discharge).

fall_fact(mechanism_sign, fall_from_height).
fall_fact(spinal_sign, head_neck_or_back_pain).
fall_fact(spinal_sign, numbness_weakness_or_tingling).
fall_fact(head_injury_sign, confusion_or_vomiting).
fall_fact(critical_mobility_sign, unable_to_move_safely).
fall_fact(position_rule, leave_in_position_when_spinal_injury_suspected).

choking_fact(scope, adult).
choking_fact(mild_sign, can_cough_speak_or_breathe).
choking_fact(severe_sign, cannot_cough_speak_or_breathe).
choking_fact(first_action_severe, five_back_blows).
choking_fact(second_action_severe, five_abdominal_thrusts).
choking_fact(unresponsive_action, begin_cpr_according_to_training).
choking_fact(finger_sweep_rule, remove_object_only_if_seen).

% ================================================================
% FORWARD-CHAINING DOMAIN RULES: 28 RULES
% ================================================================

fc_rule(r01,
        [answer(unresponsive_or_not_breathing, yes)],
        advise(call_emergency),
        'Call emergency medical help immediately.').
fc_rule(r02,
        [answer(unresponsive_or_not_breathing, yes)],
        advise(cpr_if_trained),
        'If the person is not breathing normally, begin CPR according to your training.').

fc_rule(r03,
        [accident(burn), answer(burn_within_3_hours, yes)],
        advise(cool_burn_20_minutes),
        'Cool the burn under cool running water for 20 minutes.').
fc_rule(r04,
        [accident(burn), answer(running_water_available, no)],
        advise(use_cool_bottled_water_or_wet_towel),
        'If running water is unavailable, use cool bottled water or a cool wet towel.').
fc_rule(r05,
        [accident(burn), answer(nearby_clothing_or_jewellery, yes), answer(stuck_to_skin, no)],
        advise(remove_nearby_clothing_jewellery),
        'Remove nearby clothing or jewellery, but only if it is not stuck to the skin.').
fc_rule(r06,
        [accident(burn), answer(stuck_to_skin, yes)],
        advise(do_not_remove_stuck_material),
        'Do not remove clothing or material that is stuck to the burn.').
fc_rule(r07,
        [accident(burn), answer(burn_cooled, yes)],
        advise(cover_loose),
        'After cooling, lay a loose covering such as cling film over the burn; do not wrap tightly.').
fc_rule(r08,
        [accident(burn), answer(burn_large_or_deep, yes)],
        advise(urgent_medical_help),
        'A large or deep burn needs urgent medical assessment.').
fc_rule(r09,
        [accident(burn), answer(burn_on_face_or_airway, yes)],
        advise(urgent_medical_help),
        'A burn involving the face or airway area requires urgent medical help.').
fc_rule(r10,
        [accident(burn), answer(ice_or_home_remedy_used, yes)],
        advise(stop_ice_or_home_remedy),
        'Do not use ice or home remedies such as butter or toothpaste on the burn.').

fc_rule(r11,
        [accident(cut)],
        advise(wash_hands_or_use_gloves),
        'Wash hands and use disposable gloves if available before treating the wound.').
fc_rule(r12,
        [accident(cut), answer(bleeding_heavily, yes)],
        advise(apply_direct_pressure),
        'Apply firm direct pressure with a clean cloth or dressing to control heavy bleeding.').

fc_rule(r13,
        [accident(cut), answer(object_stuck_in_wound, yes)],
        advise(do_not_remove_object),
        'Do not remove an object embedded in the wound; avoid pressing directly on it and seek urgent help.').
fc_rule(r14,
        [accident(cut), answer(bleeding_stopped_with_pressure, yes)],
        advise(clean_and_cover_wound),
        'Once bleeding has stopped, clean the wound and cover it with a plaster or dressing.').
fc_rule(r15,
        [accident(cut), answer(infection_signs_present, yes)],
        advise(seek_medical_advice),
        'Increasing redness, swelling, pain, coloured discharge or fever can indicate infection; seek medical advice.').
fc_rule(r16,
        [accident(cut), answer(bleeding_severe_or_uncontrolled, yes)],
        advise(call_emergency),
        'Severe or uncontrolled bleeding requires emergency medical help.').

fc_rule(r17,
        [accident(fall), answer(fall_from_height, yes)],
        advise(consider_spinal_injury),
        'A fall from height can indicate a spinal injury; avoid unnecessary movement.').
fc_rule(r18,
        [accident(fall), answer(head_neck_back_pain, yes)],
        advise(do_not_move_call_help),
        'Do not ask the person to move; leave them in position and call emergency help.').
fc_rule(r19,
        [accident(fall), answer(numbness_weakness_or_tingling, yes)],
        advise(urgent_medical_help),
        'Numbness, weakness or tingling after a fall is an emergency warning sign.').
fc_rule(r20,
        [accident(fall), answer(confusion_or_vomiting, yes)],
        advise(urgent_medical_help),
        'Confusion or vomiting after a fall needs urgent medical assessment.').
fc_rule(r21,
        [accident(fall), answer(unable_to_move_safely, yes)],
        advise(urgent_medical_help),
        'If the person cannot safely move an injured area, seek urgent medical help.').
fc_rule(r22,
        [accident(fall), answer(spinal_injury_suspected, yes)],
        advise(keep_position_found),
        'Leave the person in the position found unless movement is necessary for immediate safety, CPR or bleeding control.').

fc_rule(r23,
        [accident(choking), answer(can_cough_speak_breathe, yes)],
        advise(encourage_cough),
        'For mild choking, encourage the person to keep coughing.').
fc_rule(r24,
        [accident(choking), answer(can_cough_speak_breathe, no)],
        advise(five_back_blows),
        'For severe choking in an adult, give up to five back blows.').
fc_rule(r25,
        [accident(choking), answer(can_cough_speak_breathe, no), answer(back_blows_cleared_blockage, no)],
        advise(five_abdominal_thrusts),
        'If back blows do not clear the blockage, give up to five abdominal thrusts to an adult.').
fc_rule(r26,
        [accident(choking), answer(can_cough_speak_breathe, no), answer(blockage_cleared, no)],
        advise(repeat_back_blows_and_abdominal_thrusts),
        'If the blockage remains, continue the back-blow and abdominal-thrust cycle while waiting for emergency help.').
fc_rule(r27,
        [accident(choking), answer(person_becomes_unresponsive, yes)],
        advise(cpr_if_trained),
        'If the choking person becomes unresponsive and is not breathing normally, begin CPR according to training.').
fc_rule(r28,
        [accident(choking), answer(visible_object_in_mouth, no)],
        advise(do_not_blind_finger_sweep),
        'Do not perform a blind finger sweep; remove an object only when you can see it.').

% ================================================================
% QUICK ADVICE - FORWARD CHAINING / FULL ASSESSMENT
% ================================================================

quick_advice :-
    reset_memory,
    print_mode_header('QUICK ADVICE',
                      'FULL ASSESSMENT',
                      'All relevant scenario questions will be asked.',
                      cyan),
    ask_accident(Accident),
    assertz(observed(accident(Accident))),
    ask_common_triage,
    ( observed(answer(unresponsive_or_not_breathing, yes)) ->
        true
    ;
        ask_questions_for(Accident)
    ),
    run_forward_reasoning,
    show_quick_result,
    clear_memory.

run_forward_reasoning :-
    retractall(derived(_)),
    forward_cycle.

forward_cycle :-
    findall(Id-Conclusion,
            ( fc_rule(Id, Conditions, Conclusion, _Text),
              \+ derived(rule(Id)),
              conditions_hold(Conditions),
              \+ derived(Conclusion) ),
            NewRules),
    ( NewRules = [] ->
        true
    ;
        forall(member(Id-Conclusion, NewRules),
               ( assertz(derived(rule(Id))),
                 assertz(derived(Conclusion)) )),
        forward_cycle
    ).

conditions_hold([]).
conditions_hold([Fact|Rest]) :-
    holds(Fact),
    conditions_hold(Rest).

holds(Fact) :- observed(Fact), !.
holds(Fact) :- derived(Fact), !.

show_quick_result :-
    nl,
    print_rule_heading('ASSESSMENT RESULT', cyan),
    ( derived(advise(call_emergency)) ->
        print_decision_red('URGENT MEDICAL HELP NEEDED'),
        nl,
        print_rule_heading('EMERGENCY ACTION', red),
        emergency_message,
        nl
    ;
        print_decision_green('FIRST-AID GUIDANCE'),
        nl
    ),
    show_numbered_recommendations,
    nl,
    print_rule_heading('WHY', cyan),
    writeln('The recommendations below were triggered by the answers provided.'),
    nl.

show_numbered_recommendations :-
    findall(A, derived(advise(A)), AdviceList),
    ( AdviceList = [] ->
        print_color([fg(yellow)], 'No additional recommendation was triggered.~n', [])
    ;
        print_rule_heading('RECOMMENDATIONS', green),
        show_numbered_recommendations(AdviceList, 1)
    ).

show_numbered_recommendations([], _).
show_numbered_recommendations([A|Rest], N) :-
    advice_text(A, Text),
    ansi_format([bold,fg(green)], '  ~d. ~w~n', [N, Text]),
    Next is N + 1,
    show_numbered_recommendations(Rest, Next).

% ================================================================
% TARGETED HELP - BACKWARD CHAINING / URGENT TRIAGE ONLY
% ================================================================

/*
   Targeted Help starts from the goal:
       need_emergency_help(Accident)

   It asks only for evidence that can prove that goal.
   A successful path stops the search immediately.
*/

targeted_help :-
    reset_memory,
    print_mode_header('TARGETED HELP',
                      'URGENT TRIAGE',
                      'Only urgent-warning questions will be asked.',
                      magenta),
    writeln('Goal: decide whether urgent medical help is needed.'),
    nl,
    ask_accident(Accident),
    ask_common_triage,
    ( observed(answer(unresponsive_or_not_breathing, yes)) ->
        show_targeted_emergency(common_unresponsive)
    ;
        ( prove_goal(need_emergency_help(Accident), Evidence) ->
            show_targeted_emergency(Evidence)
        ;
            show_no_targeted_trigger(Accident)
        )
    ),
    clear_memory.

goal_rule(need_emergency_help(burn),
          [[burn_large_or_deep],
           [burn_on_face_or_airway]]).
goal_rule(need_emergency_help(cut),
          [[heavy_or_uncontrolled_bleeding],
           [object_embedded]]).
goal_rule(need_emergency_help(fall),
          [[fall_from_height],
           [head_neck_back_pain],
           [numbness_weakness_or_tingling],
           [confusion_or_vomiting],
           [unable_to_move_safely]]).
goal_rule(need_emergency_help(choking),
          [[severe_choking]]).

prove_goal(Goal, Evidence) :-
    goal_rule(Goal, Alternatives),
    try_alternatives(Alternatives, Evidence),
    assertz(observed(goal_fact(Goal))),
    !.

try_alternatives([Requirements|_], Evidence) :-
    prove_requirements(Requirements, Evidence),
    !.
try_alternatives([_|Rest], Evidence) :-
    try_alternatives(Rest, Evidence).

prove_requirements([], []).
prove_requirements([Evidence|Rest], [Evidence|Trace]) :-
    prove_evidence(Evidence),
    prove_requirements(Rest, Trace).

prove_evidence(burn_large_or_deep) :-
    ask_once('Is the burn large or deep', burn_large_or_deep, yes).
prove_evidence(burn_on_face_or_airway) :-
    ask_once('Is the burn on the face or near the airway', burn_on_face_or_airway, yes).
prove_evidence(heavy_or_uncontrolled_bleeding) :-
    ask_once('Is the bleeding heavy or still uncontrolled', heavy_or_uncontrolled_bleeding, yes).
prove_evidence(object_embedded) :-
    ask_once('Is an object stuck in the wound', object_embedded, yes).
prove_evidence(fall_from_height) :-
    ask_once('Was the fall from a height', fall_from_height, yes).
prove_evidence(head_neck_back_pain) :-
    ask_once('Is there head, neck or back pain', head_neck_back_pain, yes).
prove_evidence(numbness_weakness_or_tingling) :-
    ask_once('Is there numbness, weakness or tingling', numbness_weakness_or_tingling, yes).
prove_evidence(confusion_or_vomiting) :-
    ask_once('Is there confusion or vomiting after the fall', confusion_or_vomiting, yes).
prove_evidence(unable_to_move_safely) :-
    ask_once('Is the person unable to move safely', unable_to_move_safely, yes).
prove_evidence(severe_choking) :-
    ask_once('Can the person cough, speak or breathe', can_cough_speak_breathe, no).

ask_once(Prompt, Key, Expected) :-
    ( asked(Key) ->
        observed(answer(Key, Expected))
    ;
        ask_yes_no(Prompt, Answer),
        assertz(asked(Key)),
        assertz(observed(answer(Key, Answer))),
        Answer == Expected
    ).

show_targeted_emergency(common_unresponsive) :-
    nl,
    print_rule_heading('URGENT DECISION', red),
    print_decision_red('URGENT MEDICAL HELP NEEDED'),
    nl,
    print_rule_heading('REASON', yellow),
    print_color([fg(red)], '  1. The person is unresponsive or not breathing normally.~n', []),
    nl,
    print_rule_heading('NEXT ACTION', red),
    emergency_message,
    nl.

show_targeted_emergency([Evidence]) :-
    nl,
    print_rule_heading('URGENT DECISION', red),
    print_decision_red('URGENT MEDICAL HELP NEEDED'),
    nl,
    print_rule_heading('REASON', yellow),
    evidence_label(Evidence, Label),
    print_color([fg(red)], '  1. ~w~n', [Label]),
    nl,
    print_rule_heading('NEXT ACTION', red),
    emergency_message,
    nl.

evidence_label(burn_large_or_deep, 'The burn was reported as large or deep.').
evidence_label(burn_on_face_or_airway, 'The burn was reported on the face or near the airway.').
evidence_label(heavy_or_uncontrolled_bleeding, 'The bleeding was reported as heavy or still uncontrolled.').
evidence_label(object_embedded, 'An object was reported as stuck in the wound.').
evidence_label(fall_from_height, 'The fall was reported as being from a height.').
evidence_label(head_neck_back_pain, 'Head, neck or back pain was reported after the fall.').
evidence_label(numbness_weakness_or_tingling, 'Numbness, weakness or tingling was reported after the fall.').
evidence_label(confusion_or_vomiting, 'Confusion or vomiting was reported after the fall.').
evidence_label(unable_to_move_safely, 'The person was reported as unable to move safely.').
evidence_label(severe_choking, 'The person was reported as unable to cough, speak or breathe normally.').

show_no_targeted_trigger(Accident) :-
    nl,
    print_rule_heading('URGENT DECISION', green),
    print_decision_green('NO URGENT TRIGGER FOUND'),
    nl,
    print_rule_heading('CHECKED', cyan),
    show_checked_evidence(Accident),
    nl,
    print_rule_heading('NEXT STEP', yellow),
    writeln('The urgent-care check is complete.'),
    print_color([bold,fg(cyan)], 'For full first-aid guidance, choose Quick Advice.~n', []),
    nl.

show_checked_evidence(burn) :-
    show_check_if_asked(burn_large_or_deep, 'Large/deep burn'),
    show_check_if_asked(burn_on_face_or_airway, 'Face/airway burn').
show_checked_evidence(cut) :-
    show_check_if_asked(heavy_or_uncontrolled_bleeding, 'Heavy/uncontrolled bleeding'),
    show_check_if_asked(object_embedded, 'Object stuck in wound').
show_checked_evidence(fall) :-
    show_check_if_asked(fall_from_height, 'Fall from height'),
    show_check_if_asked(head_neck_back_pain, 'Head/neck/back pain'),
    show_check_if_asked(numbness_weakness_or_tingling, 'Numbness/weakness/tingling'),
    show_check_if_asked(confusion_or_vomiting, 'Confusion/vomiting'),
    show_check_if_asked(unable_to_move_safely, 'Unable to move safely').
show_checked_evidence(choking) :-
    show_check_if_asked(can_cough_speak_breathe, 'Can cough/speak/breathe').

show_check_if_asked(Key, Label) :-
    ( observed(answer(Key, Answer)) ->
        ansi_format([fg(cyan)], '  - ~w : ~w~n', [Label, Answer])
    ;
        true
    ).

% ================================================================
% COMMON OUTPUT / ADVICE TEXT
% ================================================================

advice_text(cool_burn_20_minutes,
            'Cool the burn under cool running water for 20 minutes.').
advice_text(use_cool_bottled_water_or_wet_towel,
            'If running water is unavailable, use cool bottled water or a cool wet towel.').
advice_text(remove_nearby_clothing_jewellery,
            'Remove nearby clothing or jewellery only when it is not stuck to the skin.').
advice_text(do_not_remove_stuck_material,
            'Do not remove material stuck to the skin.').
advice_text(cover_loose,
            'After cooling, cover the burn loosely; do not wrap tightly.').
advice_text(urgent_medical_help,
            'Seek urgent medical help for an emergency warning sign.').
advice_text(stop_ice_or_home_remedy,
            'Do not use ice or home remedies such as butter or toothpaste on the burn.').
advice_text(wash_hands_or_use_gloves,
            'Wash hands and use disposable gloves if available.').
advice_text(apply_direct_pressure,
            'Apply firm direct pressure with a clean cloth or dressing.').
advice_text(do_not_remove_object,
            'Do not remove an object embedded in the wound; seek urgent help.').
advice_text(clean_and_cover_wound,
            'When bleeding is controlled, clean and cover the wound.').
advice_text(seek_medical_advice,
            'Seek medical advice for possible infection signs.').
advice_text(consider_spinal_injury,
            'Treat the situation as a possible spinal injury and avoid unnecessary movement.').
advice_text(do_not_move_call_help,
            'Do not ask the person to move; leave them in position and call for help.').
advice_text(keep_position_found,
            'Leave the person in the position found unless movement is essential for immediate safety, CPR or bleeding control.').
advice_text(encourage_cough,
            'Encourage the person to keep coughing.').
advice_text(five_back_blows,
            'Give up to five back blows.').
advice_text(five_abdominal_thrusts,
            'If back blows do not clear the blockage, give up to five abdominal thrusts to an adult.').
advice_text(repeat_back_blows_and_abdominal_thrusts,
            'Continue five back blows and five abdominal thrusts while waiting for emergency help.').
advice_text(do_not_blind_finger_sweep,
            'Do not perform a blind finger sweep; remove an object only when it is visible.').
advice_text(cpr_if_trained,
            'If not breathing normally, begin CPR according to your training.').

emergency_message :-
    print_color([bold,fg(red)], 'CALL: 1990 Suwa Seriya (1990)~n', []),
    writeln('Follow emergency operator instructions and use first-aid/CPR steps only within your training.'),
    print_color([fg(red)], 'Do not delay emergency care to continue using this program.~n', []).

% ================================================================
% USER INPUT
% ================================================================

ask_accident(Accident) :-
    print_section('SELECT ACCIDENT', cyan),
    ansi_format([bold,fg(white)], '  [1] ', []), writeln('Burn or scald'),
    ansi_format([bold,fg(white)], '  [2] ', []), writeln('Cut or bleeding wound'),
    ansi_format([bold,fg(white)], '  [3] ', []), writeln('Fall'),
    ansi_format([bold,fg(white)], '  [4] ', []), writeln('Adult choking'),
    nl,
    ask_menu_choice(1, 4, Choice),
    choice_accident(Choice, Accident),
    ansi_format([bold,fg(green)], '  [OK] Selected scenario: ~w~n', [Accident]),
    nl.

choice_accident(1, burn).
choice_accident(2, cut).
choice_accident(3, fall).
choice_accident(4, choking).

ask_common_triage :-
    ask_yes_no('Is the person unresponsive or not breathing normally', Answer),
    assertz(observed(answer(unresponsive_or_not_breathing, Answer))).

ask_questions_for(burn) :-
    ask_yes_no('Did the burn happen within the last 3 hours', X1),
    assertz(observed(answer(burn_within_3_hours, X1))),
    ask_yes_no('Is running water available', X2),
    assertz(observed(answer(running_water_available, X2))),
    ask_yes_no('Is there clothing or jewellery near the burn', X3),
    assertz(observed(answer(nearby_clothing_or_jewellery, X3))),
    ask_yes_no('Is any material stuck to the skin', X4),
    assertz(observed(answer(stuck_to_skin, X4))),
    ask_yes_no('Has the burn cooled already', X5),
    assertz(observed(answer(burn_cooled, X5))),
    ask_yes_no('Is the burn large or deep', X6),
    assertz(observed(answer(burn_large_or_deep, X6))),
    ask_yes_no('Is the burn on the face or near the airway', X7),
    assertz(observed(answer(burn_on_face_or_airway, X7))),
    ask_yes_no('Has ice or a home remedy been applied', X8),
    assertz(observed(answer(ice_or_home_remedy_used, X8))).

ask_questions_for(cut) :-
    ask_yes_no('Is the wound bleeding heavily right now', X1),
    assertz(observed(answer(bleeding_heavily, X1))),
    ask_yes_no('Is an object stuck in the wound', X2),
    assertz(observed(answer(object_stuck_in_wound, X2))),
    ask_yes_no('Has the bleeding stopped with pressure', X3),
    assertz(observed(answer(bleeding_stopped_with_pressure, X3))),
    ask_yes_no('Is the bleeding severe or still uncontrolled', X4),
    assertz(observed(answer(bleeding_severe_or_uncontrolled, X4))),
    ask_yes_no('Are there signs of infection such as increasing redness, swelling, pain or discharge', X5),
    assertz(observed(answer(infection_signs_present, X5))).

ask_questions_for(fall) :-
    ask_yes_no('Was the fall from a height', X1),
    assertz(observed(answer(fall_from_height, X1))),
    ask_yes_no('Is there head, neck or back pain', X2),
    assertz(observed(answer(head_neck_back_pain, X2))),
    ask_yes_no('Is there numbness, weakness or tingling', X3),
    assertz(observed(answer(numbness_weakness_or_tingling, X3))),
    ask_yes_no('Is there confusion or vomiting after the fall', X4),
    assertz(observed(answer(confusion_or_vomiting, X4))),
    ask_yes_no('Is the person unable to move safely', X5),
    assertz(observed(answer(unable_to_move_safely, X5))),
    ask_yes_no('Do you suspect a head, neck or back injury', X6),
    assertz(observed(answer(spinal_injury_suspected, X6))).

ask_questions_for(choking) :-
    print_color([fg(yellow)], 'This module is limited to adult choking.~n', []),
    ask_yes_no('Can the person cough, speak or breathe', X1),
    assertz(observed(answer(can_cough_speak_breathe, X1))),
    ask_yes_no('Did five back blows clear the blockage', X2),
    assertz(observed(answer(back_blows_cleared_blockage, X2))),
    ask_yes_no('Has the blockage cleared', X3),
    assertz(observed(answer(blockage_cleared, X3))),
    ask_yes_no('Has the person become unresponsive', X4),
    assertz(observed(answer(person_becomes_unresponsive, X4))),
    ask_yes_no('Can you see an object in the mouth', X5),
    assertz(observed(answer(visible_object_in_mouth, X5))).

ask_menu_choice(Min, Max, Choice) :-
    repeat,
    ansi_format([bold,fg(yellow)], '  >> Enter choice (~w-~w): ', [Min, Max]),
    read_line_to_string(user_input, S),
    normalize_space(string(T), S),
    ( catch(number_string(N, T), _, fail),
      integer(N),
      N >= Min,
      N =< Max ->
        Choice = N, !
    ;
        ansi_format([bold,fg(red)], '  [!] Please enter a valid menu number.~n', []),
        fail
    ).

ask_yes_no(Prompt, Answer) :-
    repeat,
    ansi_format([bold,fg(yellow)], '  ?  ~w? (Y/N): ', [Prompt]),
    read_line_to_string(user_input, S),
    string_lower(S, L),
    normalize_space(string(T), L),
    ( member(T, ["y", "yes"]) ->
        Answer = yes, !
    ; member(T, ["n", "no"]) ->
        Answer = no, !
    ;
        ansi_format([bold,fg(red)], '  [!] Please enter Y or N.~n', []),
        fail
    ).

% ================================================================
% UI / MENU
% ================================================================

start :-
    reset_memory,
    banner,
    menu.

menu :-
    print_section('MAIN MENU', cyan),
    ansi_format([bold,fg(cyan)], '  [1]  QUICK ADVICE~n', []),
    writeln('       Full assessment + all applicable first-aid advice.'),
    nl,
    ansi_format([bold,fg(magenta)], '  [2]  TARGETED HELP~n', []),
    writeln('       Urgent check only + early stop when needed.'),
    nl,
    ansi_format([bold,fg(white)], '  [3]  EXIT~n', []),
    print_line,
    ask_menu_choice(1, 3, Choice),
    ( Choice =:= 3 ->
        nl,
        ansi_format([bold,fg(cyan)], 'Thank you. Stay safe.~n', []),
        nl
    ;
        menu_action(Choice),
        menu
    ).

menu_action(1) :- quick_advice.
menu_action(2) :- targeted_help.

banner :-
    nl,
    ansi_format([bold,fg(cyan)], '==============================================================~n', []),
    ansi_format([bold,fg(cyan)], '                 FIRST AID EXPERT SYSTEM                     ~n', []),
    ansi_format([bold,fg(white)], '                      SWI-PROLOG                              ~n', []),
    ansi_format([bold,fg(cyan)], '==============================================================~n', []),
    ansi_format([fg(yellow)], 'Educational coursework prototype.\n', []),
    ansi_format([fg(yellow)], 'For a real emergency, contact emergency services immediately.\n', []),
    ansi_format([bold,fg(cyan)], '==============================================================~n', []),
    nl.

print_line :-
    ansi_format([fg(cyan)], '--------------------------------------------------------------~n', []).

print_section(Title, Color) :-
    nl,
    ansi_format([bold,fg(Color)], '~w~n', [Title]),
    print_line.

print_mode_header(Mode, Purpose, Description, Color) :-
    nl,
    ansi_format([bold,fg(Color)], '==============================================================~n', []),
    ansi_format([bold,fg(Color)], '                    ~w~n', [Mode]),
    ansi_format([bold,fg(white)], '                    ~w~n', [Purpose]),
    ansi_format([fg(yellow)], '  ~w~n', [Description]),
    ansi_format([bold,fg(Color)], '==============================================================~n', []),
    nl.

print_rule_heading(Title, Color) :-
    ansi_format([bold,fg(Color)], '~w~n', [Title]),
    print_line.

print_decision_green(Text) :-
    ansi_format([bold,fg(green)], 'DECISION : ~w~n', [Text]).

print_decision_red(Text) :-
    ansi_format([bold,fg(red)], 'DECISION : ~w~n', [Text]).

print_color(Attributes, Format, Args) :-
    ansi_format(Attributes, Format, Args).

% ================================================================
% LECTURER CHECK
% ================================================================

check_system :-
    findall(A, accident_type(A), Accidents),
    findall(F, source_fact(F), Facts),
    findall(Id, fc_rule(Id, _Conditions, _Conclusion, _Text), Rules),
    findall(G, goal_rule(G, _Alternatives), Goals),
    sort(Accidents, UniqueAccidents),
    sort(Facts, UniqueFacts),
    sort(Rules, UniqueRules),
    sort(Goals, UniqueGoals),
    length(UniqueAccidents, AccidentCount),
    length(UniqueFacts, FactCount),
    length(UniqueRules, RuleCount),
    length(UniqueGoals, GoalGroupCount),
    nl,
    print_line,
    ansi_format([bold,fg(cyan)], 'SYSTEM CHECK~n', []),
    print_line,
    format('Accident categories : ~w~n', [AccidentCount]),
    format('Knowledge facts     : ~w~n', [FactCount]),
    format('Domain rules        : ~w~n', [RuleCount]),
    format('Goal rule groups    : ~w~n', [GoalGroupCount]),
    ( FactCount >= 20, RuleCount >= 20 ->
        ansi_format([bold,fg(green)], 'Assignment threshold : PASS~n', [])
    ;
        ansi_format([bold,fg(red)], 'Assignment threshold : CHECK~n', [])
    ),
    print_line,
    nl.

source_fact(accident_type(A)) :- accident_type(A).
source_fact(emergency_service(sri_lanka, S)) :- emergency_service(sri_lanka, S).
source_fact(emergency_number(sri_lanka, N)) :- emergency_number(sri_lanka, N).
source_fact(ambulance_service_scope(sri_lanka, S)) :- ambulance_service_scope(sri_lanka, S).
source_fact(burn_fact(K, V)) :- burn_fact(K, V).
source_fact(cut_fact(K, V)) :- cut_fact(K, V).
source_fact(fall_fact(K, V)) :- fall_fact(K, V).
source_fact(choking_fact(K, V)) :- choking_fact(K, V).

reset_memory :-
    retractall(observed(_)),
    retractall(derived(_)),
    retractall(asked(_)).

clear_memory :- reset_memory.

:- initialization(main, main).

main :-
    start.
