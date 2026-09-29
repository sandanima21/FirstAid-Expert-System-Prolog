# First Aid Expert System - Guide

## Run

Install SWI-Prolog, then open `first_aid_expert_system.pl`. If the `.pl` file is associated with SWI-Prolog, double-clicking it starts the CLI.

If double-click does not launch the application, open SWI-Prolog in the project folder and run:

```text
?- consult('first_aid_expert_system.pl').
?- check_system.
?- start.
```

## Modes

**Quick Advice**: full assessment and full applicable first-aid recommendations. Academic mapping: forward chaining.

**Targeted Help**: urgent-care check only. It starts from the urgent-help goal, asks only the required warning-sign questions, and stops when the goal is proved. Academic mapping: backward chaining.

## System contents

- 4 accident categories
- 34 knowledge facts
- 28 source-based domain rules
- 4 urgent-help goal groups
- Colour CLI using `library(ansi_term)`

## References

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

[S10] SWI-Prolog - library(ansi_term)  
https://www.swi-prolog.org/pldoc/man?section=ansiterm
