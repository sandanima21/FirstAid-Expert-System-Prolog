# First Aid Expert System — Lecturer README

## Run

Install **SWI-Prolog** from the official website:

https://www.swi-prolog.org/download/stable

Open the project folder and run:

```text
swipl first_aid_expert_system.pl
```

Or from the SWI-Prolog prompt:

```prolog
?- consult('first_aid_expert_system.pl').
?- check_system.
?- start.
```

## Final system status

- **Domain:** First Aid
- **Scenarios:** Burn / Cut or bleeding / Fall / Adult choking
- **Knowledge facts:** 34
- **Domain rules:** 28
- **Goal-rule groups:** 4
- **Interface:** Color-enabled CLI
- **Quick Advice:** Full assessment and all applicable advice — **Forward Chaining / Data-Driven**
- **Targeted Help:** Urgent check only with early stopping — **Backward Chaining / Goal-Driven**

## Demonstration

Use the **same accident** in both modes.

### Quick Advice
Select `1`, choose an accident, and answer the full scenario questions. The system then displays all applicable recommendations.

### Targeted Help
Select `2`, choose the same accident, and answer only the urgent-warning questions. When an urgent condition is confirmed, the system stops immediately and shows the urgent decision.

For example, for a cut:

```text
Unresponsive/not breathing: n
Heavy/uncontrolled bleeding: y
```

The urgent result should appear immediately; the remaining targeted questions are skipped.

## System check

Run:

```prolog
?- check_system.
```

Expected:

```text
Accident categories : 4
Knowledge facts     : 34
Domain rules        : 28
Goal rule groups    : 4
Assignment threshold : PASS
```

## References

1. NHS — Burns and scalds  
   https://www.nhs.uk/conditions/burns-and-scalds/
2. NHS — Cuts and grazes  
   https://www.nhs.uk/conditions/cuts-and-grazes/
3. North East Ambulance Service (NHS) — Choking  
   https://www.neas.nhs.uk/community-learning/emergency-advice/choking
4. American Red Cross — Head, Neck, and Spinal Injury  
   https://production.redcross.org/take-a-class/learn-fa-head-neck-spinal-injury.html
5. American Red Cross — First Aid/CPR/AED Participant's Manual  
   https://www.redcross.org/content/dam/redcross/training-services/no-index/First%20Aid-CPR-AED-Participant%27s-Manual.pdf
6. American Red Cross — First Aid Steps  
   https://production.redcross.org/take-a-class/first-aid/performing-first-aid/first-aid-steps
7. St John Ambulance — Spinal Injury First Aid  
   https://www.sja.org.uk/first-aid-advice/spinal-injury/
8. East of England Ambulance Service — Cuts and grazes  
   https://www.eastamb.nhs.uk/your-service/emergency-advice/cuts-and-grazes
9. 1990 Suwa Seriya Foundation — FAQ  
   https://www.1990.lk/faq/
10. SWI-Prolog — official documentation / ANSI terminal support  
    https://www.swi-prolog.org/pldoc/man?section=ansiterm

No domain expert was consulted. The medical knowledge was represented from the cited sources.

## Safety

Educational coursework prototype only. It does not replace first-aid/CPR training, professional medical assessment, or emergency-dispatcher instructions.
