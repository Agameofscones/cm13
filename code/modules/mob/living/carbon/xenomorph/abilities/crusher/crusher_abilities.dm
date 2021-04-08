/datum/action/xeno_action/activable/pounce/crusher_charge
	name = "Charge"
	action_icon_state = "ready_charge"
	ability_name = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 140
	plasma_cost = 5

	var/direct_hit_damage = 60

	// Config options
	distance = 9

	knockdown = TRUE
	knockdown_duration = 2
	slash = FALSE
	freeze_self = FALSE
	windup = TRUE
	windup_duration = 12
	windup_interruptable = FALSE
	should_destroy_objects = TRUE
	throw_speed = SPEED_FAST
	tracks_target = FALSE

	// Object types that dont reduce cooldown when hit
	var/list/not_reducing_objects = list()

/datum/action/xeno_action/activable/pounce/crusher_charge/ai
	windup = FALSE

	windup_duration = 3 SECONDS
	// When to acquire target before launching
	var/when_to_get_turf = 0.5 SECONDS
	var/charging = FALSE

/datum/action/xeno_action/activable/pounce/crusher_charge/ai/use_ability(atom/A)
	if(charging || !action_cooldown_check() || !can_use_action())
		return

	var/mob/M = owner

	M.anchored = TRUE
	M.frozen = TRUE

	var/failed = FALSE
	if(!do_after(M, windup_duration - when_to_get_turf, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE))
		failed = TRUE

	A = get_turf(A)

	if(!failed && !do_after(M, when_to_get_turf, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE))
		failed = TRUE

	M.anchored = FALSE
	M.frozen = FALSE
	charging = FALSE

	if(failed)
		return

	return ..(A)

/datum/action/xeno_action/activable/pounce/crusher_charge/New()
	. = ..()
	not_reducing_objects = typesof(/obj/structure/barricade) + typesof(/obj/structure/machinery/defenses)

/datum/action/xeno_action/activable/pounce/crusher_charge/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_CRUSHER_CHARGE

/datum/action/xeno_action/onclick/crusher_stomp
	name = "Stomp"
	action_icon_state = "stomp"
	ability_name = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 180
	plasma_cost = 20

	var/damage = 65

	var/distance = 2
	var/effect_type_base = /datum/effects/xeno_slow/superslow
	var/effect_duration = 10

/datum/action/xeno_action/onclick/crusher_shield
	name = "Defensive Shield"
	action_icon_state = "empower"
	ability_name = "defensive shield"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 260
	plasma_cost = 20

	var/shield_amount = 200
