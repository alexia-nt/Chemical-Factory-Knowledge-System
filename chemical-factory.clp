; This is a program that detects the store that has might caused a pollution.
; This is achieved by asking the user to enter some measurements.
; Based on those some chemicals turn into suspects due to their properties.
; The storages that contain the "suspect" chemical, get criminalised along with
; the manholes that are connected with them. Then the system does some follow-up
; questions in each effort to end up in only one suspect storage, by decriminalizing
; stores that are not responsible for the pollution based on user input.

; The program was developed in CLIPS 6.4.1 4/8/23
; by Alexia Ntantouri (3871), Maria-Nefeli Paraskevopoulou (3933) and Spyridon Terzis (3926)
; as a semester project for Knowledge Systems course at AUTh.
; It was executed both in CLIPS IDE and in VS Code IDE.
; It is recommended to run the program using CLIPS IDE,
; since VS Code may sometimes give upredictable output format.
; The program is case sensitive and in most user input cases we assume
; that the user gives a answer within the range of the allowed values.

(defclass chemical
	(is-a USER)
	(role concrete)
	(multislot colour
		(type SYMBOL)
		(allowed-values clear red white)
		(default clear)
		(create-accessor read-write))
	(multislot specific_gravity
		(type SYMBOL)
		(allowed-values equal_to_1 above_1 below_1)
		(default equal_to_1)
		(create-accessor read-write))
	(multislot radioactivity
		(type SYMBOL)
		(allowed-values no yes)
		(default no)
		(create-accessor read-write))
	(multislot pH-high
		(type INTEGER)
		(range 0 14)
		(create-accessor read-write))
	(multislot pH-low
		(type INTEGER)
		(range 0 14)
		(create-accessor read-write))
	(multislot solubility
		(type SYMBOL)
		(allowed-values soluble insoluble)
		(default soluble)
		(create-accessor read-write))
	(multislot smell
		(type SYMBOL)
		(allowed-values none vinegar choking)
		(default none)
		(create-accessor read-write))
	(slot suspect 
		(type SYMBOL) 
		(allowed-symbols yes no)
		(default no))
        (slot ignore 
		(type SYMBOL) 
		(allowed-symbols yes no)
		(default no))
	(multislot hazards
		(type SYMBOL)
		(allowed-values asphyxiation burns_skin explosive highly_toxic_PCBs)
		(create-accessor read-write))
	(multislot spectrometry
		(type SYMBOL)
		(allowed-values none sulphur carbon sodium metal)
		(default none)
		(create-accessor read-write)))

(defclass acid
	(is-a chemical)
	(role concrete)
	(multislot pH-high
		(type INTEGER)
		(range 0 14)
		(default 6)
		(create-accessor read-write))
	(multislot pH-low
		(type INTEGER)
		(range 0 14)
		(default 0)
		(create-accessor read-write)))

(defclass strong_acid
	(is-a acid)
	(role concrete)
	(multislot pH-high
		(type INTEGER)
		(range 0 14)
		(default 3)
		(create-accessor read-write))
	(multislot hazards
		(type SYMBOL)
		(allowed-values asphyxiation burns_skin explosive highly_toxic_PCBs)
		(default burns_skin)
		(create-accessor read-write)))

(defclass weak_acid
	(is-a acid)
	(role concrete)
	(multislot pH-low
		(type INTEGER)
		(range 0 14)
		(default 3)
		(create-accessor read-write)))

(defclass base
	(is-a chemical)
	(role concrete)
	(multislot pH-high
		(type INTEGER)
		(range 0 14)
		(default 14)
		(create-accessor read-write))
	(multislot pH-low
		(type INTEGER)
		(range 0 14)
		(default 8)
		(create-accessor read-write)))

(defclass strong_base
	(is-a base)
	(role concrete)
	(multislot pH-low
		(type INTEGER)
		(range 0 14)
		(default 11)
		(create-accessor read-write))
	(multislot hazards
		(type SYMBOL)
		(allowed-values asphyxiation burns_skin explosive highly_toxic_PCBs)
		(default burns_skin)
		(create-accessor read-write)))

(defclass weak_base
	(is-a base)
	(role concrete)
	(multislot pH-high
		(type INTEGER)
		(range 0 14)
		(default 11)
		(create-accessor read-write)))

(defclass oil
	(is-a chemical)
	(role concrete)
	(multislot pH-high
		(type INTEGER)
		(range 0 14)
		(default 8)
		(create-accessor read-write))
	(multislot pH-low
		(type INTEGER)
		(range 0 14)
		(default 6)
		(create-accessor read-write))
	(multislot solubility
		(type SYMBOL)
		(allowed-values soluble insoluble)
		(default insoluble)
		(create-accessor read-write))
	(multislot spectrometry
		(type SYMBOL)
		(allowed-values none sulphur carbon sodium metal)
		(default carbon)
		(create-accessor read-write)))

(defclass node
	(is-a USER)
	(role concrete)
	(multislot downstream
		(type INSTANCE)
		(allowed-classes node)
		(create-accessor read-write))
	(slot suspect 
		(type SYMBOL) 
		(allowed-symbols yes no)
		(default no)))


(defclass store
	(is-a node)
	(role concrete)
	(multislot contents
		(type INSTANCE)
		(allowed-classes chemical)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write)))

(defclass manhole
	(is-a node)
	(role concrete))


(definstances example-instances
([acetic_acid] of  weak_acid

	(smell vinegar))

([aluminium_hydroxide] of  weak_base

	(colour white)
	(specific_gravity above_1)
	(spectrometry metal))

([carbonic_acid] of  weak_acid

	(spectrometry carbon))

([chromogen_23] of  weak_base

	(colour red)
	(specific_gravity below_1))

([hydrochloric_acid] of  strong_acid

	(hazards asphyxiation burns_skin)
	(smell choking))

([manhole_1] of  manhole

	(downstream [manhole_9]))

([manhole_10] of  manhole

	(downstream [manhole_12]))

([manhole_11] of  manhole

	(downstream [manhole_13]))

([manhole_12] of  manhole

	(downstream [monitoring_station]))

([manhole_13] of  manhole

	(downstream [monitoring_station]))

([manhole_2] of  manhole

	(downstream [manhole_9]))

([manhole_3] of  manhole

	(downstream [manhole_9]))

([manhole_4] of  manhole

	(downstream [manhole_10]))

([manhole_5] of  manhole

	(downstream [manhole_10]))

([manhole_6] of  manhole

	(downstream [manhole_11]))

([manhole_7] of  manhole

	(downstream [manhole_11]))

([manhole_8] of  manhole

	(downstream [manhole_13]))

([manhole_9] of  manhole

	(downstream [manhole_12]))

([monitoring_station] of  node
)

([petrol] of  oil

	(hazards explosive)
	(specific_gravity below_1))

([rubidium_hydroxide] of  weak_base

	(radioactivity yes)
	(specific_gravity above_1)
	(spectrometry metal))

([sodium_hydroxide] of  strong_base

	(spectrometry sodium))

([store_1] of  store

	(contents
		[sulphuric_acid]
		[petrol])
	(downstream [manhole_1]))

([store_2] of  store

	(contents
		[hydrochloric_acid]
		[acetic_acid])
	(downstream [manhole_2]))

([store_3] of  store

	(contents
		[rubidium_hydroxide]
		[transformer_oil])
	(downstream [manhole_3]))

([store_4] of  store

	(contents
		[carbonic_acid]
		[acetic_acid]
		[petrol])
	(downstream [manhole_4]))

([store_5] of  store

	(contents
		[chromogen_23]
		[sulphuric_acid]
		[petrol])
	(downstream [manhole_5]))

([store_6] of  store

	(contents
		[aluminium_hydroxide]
		[transformer_oil]
		[carbonic_acid])
	(downstream [manhole_6]))

([store_7] of  store

	(contents
		[hydrochloric_acid]
		[sulphuric_acid])
	(downstream [manhole_7]))

([store_8] of  store

	(contents
		[acetic_acid]
		[carbonic_acid]
		[sodium_hydroxide])
	(downstream [manhole_8]))

([sulphuric_acid] of  strong_acid

	(spectrometry sulphur))

([transformer_oil] of  oil

	(hazards highly_toxic_PCBs))
)

; function that takes ?question and $?allowed-values as parameters
; asks the question and returns the user's answer if it is within the allowed values
; pre-made function taken by CLIPS Lecture 2 Slides

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer $?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
         then (bind ?answer (lowcase ?answer))))
 	 (return ?answer)
)

; initial rule that asks which measurements the user will provide to the knowledge system
(defrule initial-rule 
     => 
    (printout t "Gia poies metriseis tha dothoyn times? (pH solubility spectrometry colour smell specific_gravity radioactivity)" crlf)
    (bind ?params (readline))
    (set-strategy depth)
    (assert (user-input ?params))
    (assert (goal make-suspects))
) 

; rule that asks about the pH measurement and asserts the pHValue into the agenda
(defrule ask-pH
	(user-input ?params)
	(test (neq (str-index "pH" ?params) FALSE))
	=>
	(printout t "Poio einai to pH ths molinsis?" crlf)
        (bind ?pH (read))
	(assert (pHValue ?pH))
)

; rule that asks about the solubility measurement and asserts the solubilityValue into the agenda
(defrule ask-solubility
	(user-input ?params)
	(test (neq (str-index "solubility" ?params) FALSE))
	=>
	(printout t "Poia einai h dialytothta ths molinsis? (soluble, insoluble)" crlf)
	(bind ?solubility (read))
	(assert (solubilityValue ?solubility))
)

; rule that asks about the spectrometry measurement and asserts the spectrometryValue into the agenda
(defrule ask-spectrometry
	(user-input ?params)
	(test (neq (str-index "spectrometry" ?params) FALSE))
	=>
	(printout t "Ti deixnei h fasmatoskopia gia th molinsh? (none, sulphur, carbon, sodium, metal)" crlf)
	(bind ?spectrometry (read))
	(assert (spectrometryValue ?spectrometry))
)

; rule that asks about the colour measurement and asserts the colourValue into the agenda
(defrule ask-colour
	(user-input ?params)
	(test (neq (str-index "colour" ?params) FALSE))
	=>
	(printout t "Poio einai to xrwma ths molinsis?(none, white, red)" crlf)
        (bind ?colour (read))
	(assert (colourValue ?colour))
)

; rule that asks about the smell measurement and asserts the smellValue into the agenda
(defrule ask-smell
	(user-input ?params)
	(test (neq (str-index "smell" ?params) FALSE))
	=>
	(printout t "Ti osmi exei h molinsi? (none, choking, vinegar)" crlf)
	(bind ?smell (read))
	(assert (smellValue ?smell))
)

; rule that asks about the specific_gravity measurement and asserts the specific_gravityValue into the agenda
(defrule ask-specific_gravity
	(user-input ?params)
	(test (neq (str-index "specific_gravity" ?params) FALSE))
	=>
	(printout t "Poio einai to eidiko baros ths molinsis? (0.9 - 1.1)" crlf)
	(bind ?specific_gravity (read))
	(if (< ?specific_gravity 1)
	 then (assert (specific_gravityValue below_1))
	 else (if (> ?specific_gravity 1)
	        then (assert (specific_gravityValue above_1))
	        else (assert (specific_gravityValue equal_to_1))
	      )
	)
)

; rule that asks about the radioactivity measurement and asserts the radioactivityValue into the agenda
(defrule ask-radioactivity
	(user-input ?params)
	(test (neq (str-index "radioactivity" ?params) FALSE))
	=>
	(printout t "Einai radienergos h molinsh? (yes, no)" crlf)
        (bind ?radioactivity (read))
	(assert (radioactivityValue ?radioactivity))
)

; rule that makes chemicals suspects based on the pH value
; given by the user and the range of the pH value of each chemical
(defrule ident-class-pH
	(pHValue ?pH)
        (object (is-a chemical)
             (name ?c)
             (pH-low ?l)
             (pH-high ?h))
	=>
	(if (and (> ?pH ?l) (< ?pH ?h))
	then (modify-instance ?c (suspect yes)) 
	else (modify-instance ?c (ignore yes))
	)
)

; rule that makes chemicals suspects based on the solubility value
; given by the user and the solubility value of each chemical
(defrule ident-class-solubility
	(solubilityValue ?solubility)
	(object (is-a chemical)
             (name ?c)
             (solubility ?d))
	=>
      	(if (eq ?solubility ?d)
	then (modify-instance ?c (suspect yes)) 
	else (modify-instance ?c (ignore yes))
	)
)

; rule that makes chemicals suspects based on the radioactivity value
; given by the user and the radioactivity value of each chemical
(defrule ident-class-radioactivity
	(radioactivityValue ?radioactivity)
	(object (is-a chemical)
             (name ?c)
             (radioactivity ?d))
	=>
      	(if (eq ?radioactivity ?d)
	then (modify-instance ?c (suspect yes)) 
        else (modify-instance ?c (ignore yes))
	)
)

; rule that makes chemicals suspects based on the specific_gravity value
; given by the user and the specific_gravity value of each chemical
(defrule ident-class-specific_gravity
	(specific_gravityValue ?specific_gravity)
        (object (is-a chemical)
             (name ?c)
             (specific_gravity ?d))
	=>
      	(if (eq ?specific_gravity ?d)
	then (modify-instance ?c (suspect yes)) 
	else (modify-instance ?c (ignore yes))
	)
)

; rule that makes chemicals suspects based on the spectrometry value
; given by the user and the spectrometry value of each chemical
(defrule ident-class-spectrometry
	(spectrometryValue ?spectrometry)
        (object (is-a chemical)
             (name ?c)
             (spectrometry ?d))
	=>
      	(if (eq ?spectrometry ?d)
	then (modify-instance ?c (suspect yes)) 
        else (modify-instance ?c (ignore yes))
        )
)

; rule that makes chemicals suspects based on the smell value
; given by the user and the smell value of each chemical
(defrule suspect-smell
	(smellValue ?smell)
        (object (is-a chemical)
             (name ?c)
             (smell ?d))
	=>
      	(if (eq ?smell ?d)
	then (modify-instance ?c (suspect yes)) 
        else (modify-instance ?c (ignore yes))
	)
)

; rule that makes chemicals suspects based on the colour value
; given by the user and the colour value of each chemical
(defrule suspect-colour
	(colourValue ?colour)
        (object (is-a chemical)
             (name ?c)
             (colour ?d))
	=>
      	(if (eq ?colour ?d)
	then (modify-instance ?c (suspect yes)) 
	else (modify-instance ?c (ignore yes))
	)
)

; rule that makes stores suspects based on the suspect chemicals that they contain
(defrule predict-pollution
    	(declare (salience -1))
    	(goal make-suspects)
    	(object (is-a chemical) 
            (name ?c) 
            (suspect yes) 
            (ignore no))
    	(object (is-a store)
	    (name ?s)
	    (contents $? ?c $?))
    	=>
    	(modify-instance ?s (suspect yes))
    	(assert (goal finish-sus))
)

; rule that makes manholes suspect based on the suspect stores that they are connected to
(defrule propagate-suspect
	(declare (salience -2))
	(goal make-suspects)
	(object (is-a node) 
		(name ?st) 
		(suspect yes)
		(downstream $? ?m $?))
	(object (is-a manhole) 
		(name ?m))
  	=>
	(modify-instance ?m (suspect yes))
    	(assert (goal finish-sus))
)

; rule that initiates manhole investigation since there are more than one suspect stores
(defrule finished-sus
	(declare (salience -3))
	?x1<-(goal finish-sus)
	?x2<-(goal make-suspects)
	(object (is-a store)
              (suspect yes)
              (name ?c))
	(object (is-a store)
              (suspect yes)
              (name ?c2&~?c))
	=>
	(retract ?x1)
	(retract ?x2)
	(assert (goal initiate-manholes))
)

; rule that calls print function since there is only one suspect store
(defrule finish-print
     (declare (salience -4))
     ?x1<-(goal finish-sus)
     ?x2<-(goal make-suspects)
   =>
     (retract ?x1)
     (retract ?x2)
     (assert (goal print))
)


; transition of goal from making manholes suspect to finding leak
(defrule con-leak
    ?x1<-(goal initiate-manholes)
    =>
     (retract ?x1)
     (assert (goal find-leak))
)

; rule that finds the leak starting from the monitoring station
; if there are more than one suspect manholes connected to the monitoring station then the program asks if one of them has leakage
; and if the answer is negative, then it decriminalizes the suspect manholes that are connected with this manhole
; else, it decriminalizes the suspect manholes that are connected with the other manhole
(defrule find-leak
       (declare (salience -4))
       (goal find-leak)
       (object (is-a node)
               (name ?nod)
               (suspect no))  ; monitoring station
       (object (is-a manhole)
               (name ?c1)
               (downstream ?nod)
               (suspect yes))
       (object (is-a manhole)
               (name ?c2&~?c1)
               (downstream ?nod)
               (suspect yes))
=>
       (printout t "Yparxei molynsh sto freatio " ?c1 "? (yes/no)" crlf)
       (bind ?diaroi (ask-question " " yes no))
       (if(eq ?diaroi no)
            then  (assert (decriminalize ?c1))
            else  (assert (decriminalize ?c2)))
)

; rule that finds the leak not starting from the monitoring station (between the manholes)
; if there are more than one suspect manholes connected to this specific manhole then the program asks if one of them has leakage
; and if the answer is negative, then it decriminalizes the suspect manholes that are connected with this manhole
; else, it decriminalizes the suspect manholes that are connected with the other manhole
(defrule find-leak-2
       (declare (salience -5))
       (goal find-leak)
       (object (is-a manhole)
               (name ?nod)
               (suspect yes)
               (downstream ?nd))
       (object (is-a manhole)
               (name ?c1)
               (downstream ?nod)
               (suspect yes))
       (object (is-a manhole)
               (name ?c2&~?c1)
               (downstream ?nod)
               (suspect yes))
=>
       (printout t "Yparxei molynsh sto freatio " ?c1 "? (yes/no)" crlf)
       (bind ?diaroi (ask-question " " yes no))
       (if(eq ?diaroi no)
            then  (assert (decriminalize ?c1))
            else  (assert (decriminalize ?c2)))
)

; rule that calls print function since there is only one suspect store after decrininalization 
(defrule leak-found
       (goal find-leak)
       (object (is-a store)
               (name ?s)
               (suspect yes))
       (not (object (is-a store)
               (name ?s2&~?s)
               (suspect yes))
       )
=>
       (assert (goal print))
)

; rule that decriminalizes the suspect manholes that are directly connected to a decriminalized manhole
; and asserts goal to decriminalize the non-directly connected suspect manholes
(defrule decriminalize-this-manhole
     ?x <-(decriminalize ?manhole)
     (object (is-a manhole)
             (name ?manhole)
             (suspect yes))
 =>
    (retract ?x)
    (modify-instance ?manhole 
             (suspect no))
    (assert (goal decriminalize-rest-manholes))
)

; rule that decriminalizes the rest suspect manholes
(defrule decriminalize-rest-manholes
     (goal decriminalize-rest-manholes)
     (object (is-a manhole)
              (name ?c)
              (suspect no))
     (object (is-a manhole)
              (name ?c2)
              (suspect yes)
              (downstream ?c))
=>
     (modify-instance ?c2
             (suspect no))
)

; transition of goal from decriminalizing suspect manholes to decriminalizing suspect stores
(defrule continue-dec
     ?x1<-(goal decriminalize-rest-manholes)
=>
       (retract ?x1)
       (assert (goal dec-store))
)

; rule that decriminalize stores that are connected to a non-suspect Manhole
(defrule decriminalize-store
     (goal dec-store)
     (object (is-a store)
             (name ?st)
             (downstream ?m)
             (suspect yes))
     (object (is-a manhole)
             (name ?m)
             (suspect no))
=>
     (modify-instance ?st
            (suspect no))  
)

; rule the print the suspect chemicals
; and the hazards if those exists
(defrule print-suspect-ChemicalCompound
    (declare (salience -5))
    (goal print)
    ?chem <- (object (is-a chemical)
                    (name ?s)
                    (suspect yes)
                    (ignore no)
                    (hazards $?haz)
    )
    =>
    (printout t "To xhmiko poy prokalese th molynsh pithanon na einai to " ?s crlf)
    (if (> (length$ ?haz) 0)
        then
        (printout t "Pithanoi kindynoi: " ?haz crlf)
    )
)

; rule that prints the suspect store
(defrule print-suspect-Store
      (declare (salience -6))
      (goal print)
      (object (is-a store)
              (name ?s)
              (suspect yes)
      )
=>
      (printout t "H phgh ths molynshs einai h apothiki " ?s crlf)
)
