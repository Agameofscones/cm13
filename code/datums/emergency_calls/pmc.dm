
//Weston-Yamada commandos. Friendly to USCM, hostile to xenos.
/datum/emergency_call/pmc
	name = "Weston-Yamada PMC (Squad)"
	mob_max = 6
	probability = 25
	shuttle_id = "Distress_PMC"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	max_medics = 1
	max_heavies = 2


/datum/emergency_call/pmc/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Royce responding to your distress call. We are boarding. Any hostile actions will be met with lethal force."
	objectives = "Secure the Corporate Liaison and the [MAIN_SHIP_NAME] Captain, and eliminate any hostile threats. Do not damage W-Y property."


/datum/emergency_call/pmc/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weston-Yamada squad leader!"))
		arm_equipment(mob, "Weston-Yamada PMC (Leader)", TRUE, TRUE)
	else if(medics < max_medics)
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weston-Yamada medic!"))
		arm_equipment(mob, "Weston-Yamada PMC (Medic)", TRUE, TRUE)
	else if(heavies < max_heavies*ERT_PMC_GUNNER_FRACTION)
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weston-Yamada heavy gunner!"))
		arm_equipment(mob, "Weston-Yamada PMC (Gunner)", TRUE, TRUE)
	else if(heavies < max_heavies)
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weston-Yamada sniper!"))
		arm_equipment(mob, "Weston-Yamada PMC (Sniper)", TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weston-Yamada mercenary!"))
		arm_equipment(mob, "Weston-Yamada PMC (Standard)", TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/pmc/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weston-Yamada has proven to be very profitable for you."))
	to_chat(M, SPAN_BOLD("While you are officially an employee, much of your work is off the books. You work as a skilled mercenary."))
	to_chat(M, SPAN_BOLD("You are [pick(50;"unaware of the xenomorph threat", 15;"acutely aware of the xenomorph threat", 10;"well-informed of the xenomorph threat")]"))
	to_chat(M, "")
	to_chat(M, "")
	to_chat(M, SPAN_BOLD("You are part of  Weston-Yamada Task Force Oberon that arrived in 2182 following the UA withdrawl of the Tychon's Rift sector."))
	to_chat(M, SPAN_BOLD("Task-force Oberon is stationed aboard the USCSS Royce, a powerful Weston-Yamada cruiser that patrols the outer edges of Tychon's Rift. "))
	to_chat(M, SPAN_BOLD("Under the directive of Weston-Yamada board member Johan Almric, you act as private security for Weston-Yamada science teams."))
	to_chat(M, SPAN_BOLD("The USCSS Royce contains a crew of roughly two hundred PMCs, and one hundred scientists and support personnel."))
	to_chat(M, "")
	to_chat(M, "")
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weston-Yamada. Make sure the CL is safe."))
	to_chat(M, SPAN_BOLD("Deny Weston-Yamada's involvement and do not trust the UA/USCM forces."))


/datum/emergency_call/pmc/platoon
	name = "Weston-Yamada PMC (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
	max_medics = 2
	max_heavies = 4

/datum/emergency_call/pmc/chem_retrieval
	name = "Weston-Yamada PMC (Chemical Investigation Squad)"
	mob_max = 6
	mob_min = 2
	probability = 0
	max_medics = 2
	max_heavies = 1
	var/checked_objective = FALSE

/datum/emergency_call/pmc/chem_retrieval/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Royce. Our squad is boarding to to retrieve all samples of the chemical [objective_info] from your research department. You should already have received a significant sum of money for your department's discovery. In return we ask that you cooperate and provide everything related to [objective_info] to our retrieval team. If you do not cooperate, the team is authorized to use lethal force and terminate the research department."
	objectives = "Secure all documents, samples and chemicals containing the property DNA_Disintegrating from [MAIN_SHIP_NAME] research department."

/datum/emergency_call/pmc/chem_retrieval/proc/check_objective_info()
	if(objective_info)
		objectives = "Secure all documents, samples and chemicals related to [objective_info] from [MAIN_SHIP_NAME] research department."
	objectives += "Assume at least 30 units are located within the department. If they can not make more that should be all. Cooperate with the onboard CL to ensure all who know the complete recipe are kept silenced with a contract of confidentiality. All humans who have ingested the chemical must be brought back dead or alive. Viral scan is required for any humans who is suspected of ingestion. Full termination of the department is authorized if they do not cooperate, but this should be avoided UNLESS ABSOLUTELY NECESSARY. Assisting with [MAIN_SHIP_NAME] current operation is only allowed after successful retrieval and with a signed contract between the CL and acting commander of [MAIN_SHIP_NAME]."
	checked_objective = TRUE

/datum/emergency_call/pmc/chem_retrieval/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!checked_objective)
		check_objective_info()

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.key = M.key
	if(H.client)
		H.client.change_view(world_view_size)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("You are a Weston-Yamada squad leader!"))
		arm_equipment(H, "Weston-Yamada PMC (Lead Investigator)", TRUE, TRUE)
	else if(medics < max_medics)
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a Weston-Yamada medical investigator!"))
		arm_equipment(H, "Weston-Yamada PMC (Medical Investigator)", TRUE, TRUE)
	else if(heavies < max_heavies)
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("You are a Weston-Yamada heavy gunner!"))
		arm_equipment(H, "Weston-Yamada PMC (Gunner)", TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a Weston-Yamada detainer!"))
		arm_equipment(H, "Weston-Yamada PMC (Detainer)", TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)
/obj/effect/landmark/ert_spawns/distress_pmc
	name = "Distress_PMC"

/obj/effect/landmark/ert_spawns/distress_pmc/item
	name = "Distress_PMCitem"
