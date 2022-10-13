# High Temperature Test Facility Description

The High Temperature Test Facility (HTTF) is an electrically heated, helium cooled, 
experimental facility located at Oregon State University (OSU). Designed as a scaling 
facility for the Modular High Temperature Gas Reactor (MHTGR), the HTTF produces thermal 
hydraulic conditions expected in advanced gas-cooled nuclear reactors. The HTTF consists of 
a prismatic ceramic core which accommodates 516 coolant channels, 42 bypass channels, and 210 
electric heating elements. Coupled to the core is a steam generator for full thermodynamic 
analysis of a gas-cooled reactor system. To provide a radiative boundary for core heat loss 
quantification, the HTTF core is surrounded by the Reactor Cavity Cooling System (RCCS). 
The RCCS is a square array of steel panels accommodating water flow which surrounds the 
reactor pressure vessel (RPV) of the HTTF. Outside the RCCS water panels is a layer of 
fiberglass insulation which serves as the final thermal boundary between the HTTF system 
and ambient conditions of the room.

Coolant is provided to the RPV via the inlet portion of the combined inlet/outlet duct. 
Entering coolant travels upwards around the core in the upcomer. The upcomer leads into 
the upper plenum where the coolant makes a 180° turn and flows downward into the 
core coolant channels. After heating in the coolant channels, the coolant exhausts into the 
lower plenum, takes a 90° turn, and exits the RPV via the outlet portion of the 
combined inlet/outlet duct. A detailed description of the HTTF can be found [here](https://www.osti.gov/biblio/1599410-osu-high-temperature-test-facility-design-technical-report-revision)

Instrumentation in the HTTF core provides gas concentration, ceramic core temperature,
coolant temperature, and system pressure. A detailed description of the HTTF instrumentation can be found [here](https://www.osti.gov/biblio/1599628-instrumentation-plan-osu-high-temperature-test-facility-revision)

# PG-26 Transient Description

Tests have been conducted at the HTTF to provide experimental data for hypothetical
transients in gas-cooled nuclear reactors. Specifically, the PG-26 transient aimed to 
simulate a Depressurized Conduction Cooldown (DCC). The DCC transient emulates a
reactor which undergoes a simultaneous power excursion, loss of forced convective coolant 
flow, and depressurization of the primary system. To accomplish this, the HTTF underwent 
the following transient progression:

       1) t = 0-180,000 s

              a) Heat up

       2) t = 180,000 s

              a) Turn off primary loop gas circulator
              b) Depressurize primary loop to atmospheric conditions

       3) t = 180,000-213,000 s

              a) Increase electric heater power to emulate reactor power excursion
              b) Slowly decrease electric heater power to emulate decay heat curve of nuclear 
              reactor core

       4) t = 213,000-270,000 s

              a) Shut off electric heater power, monitor temperatures

Of note, the transient had a few anomalies which affected the results. During part 1 of the 
transient, a slow coolant leak occurred in the primary system which caused a decrease in 
primary coolant inventory. HTTF operators were able to fix the leak during the 
test, however, the amount of coolant lost, amount of make-up coolant added, temperature of 
the make-up coolant, and the time of the make-up coolant addition were unknown during the 
making of this model.

During parts 2 and 3 of the transient multiple thermocouples temporarily failed due to the 
high temperatures experienced in the HTTF core. This resulted in experimental data sets 
which include instantaneous changes in temperature which are not realistic.

At approximately t = 213,000 s, one of the electric heater banks failed and lost power. To 
preserve core symmetry HTTF operators turned off the other operating heater bank. This 
resulted in a premature termination of part 3 of the transient. 

