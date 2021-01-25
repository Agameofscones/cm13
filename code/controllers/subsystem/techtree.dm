SUBSYSTEM_DEF(techtree)
	name = "Tech Tree"
	init_order	= SS_INIT_TECHTREE
	priority = SS_PRIORITY_TECHTREE

	flags = SS_NO_FIRE

	wait = 5 SECONDS

	var/list/datum/tech/techs = list()
	var/list/datum/techtree/trees = list()

	var/list/obj/structure/resource_node/resources = list()

/datum/controller/subsystem/techtree/Initialize()
	var/list/tech_trees = subtypesof(/datum/techtree)
	var/list/tech_nodes = subtypesof(/datum/tech)

	if(!tech_trees.len)
		log_admin(SPAN_DANGER("Error setting up tech trees, no datums found."))
	if(!tech_nodes.len)
		log_admin(SPAN_DANGER("Error setting up tech nodes, no datums found."))

	for(var/T in tech_trees)
		var/datum/techtree/tree = new T()
		if(tree.flags == NO_FLAGS)
			qdel(tree)
			continue

		trees += list("[tree.name]" = tree)

		var/datum/space_level/zpos = SSmapping.add_new_zlevel(tree.name, list(ZTRAIT_TECHTREE))
		tree.zlevel = zpos

		var/zlevel = zpos.z_value
		var/turf/z_min = locate(1, 1, zlevel)
		var/turf/z_max = locate(world.maxx, world.maxy, zlevel)

		var/obj/structure/resource_node/passive_node = new(z_max, FALSE, FALSE)
		passive_node.set_tree(tree.name)

		tree.passive_node = passive_node

		for(var/t in block(z_min, z_max))
			var/turf/Tu = t
			Tu.ChangeTurf(/turf/closed/void, list(/turf/closed/void))
			new /area/techtree(Tu)

		for(var/tier in tree.tree_tiers)
			tree.unlocked_techs += tier
			tree.all_techs += tier
			tree.unlocked_techs[tier] = list()
			tree.all_techs[tier] = list()

		for(var/N in tech_nodes)
			var/datum/tech/node = new N()
			var/tier = node.tier

			if(node.flags == NO_FLAGS || !(tier in tree.all_techs))
				qdel(node)
				continue

			if(tree.flags & node.flags)
				tree.all_techs[tier] += list(node.type = node)
				techs += node

				node.tier = tree.tree_tiers[node.tier]
				node.holder = tree

		tree.generate_tree()
		var/msg = "Loaded [tree.name] Techtree!"
		to_chat(world, "<span class='boldannounce'>[msg]</span>")

	. = ..()

/datum/controller/subsystem/techtree/proc/activate_passive_nodes()
	for(var/name in trees)
		var/datum/techtree/T = trees[name]

		if(T.passive_node.active)
			continue

		T.passive_node.make_active()

/datum/controller/subsystem/techtree/proc/activate_all_nodes()
	for(var/obj/structure/resource_node/RN in resources)
		if(QDELETED(RN))
			resources.Remove(RN)
			continue

		if(RN.active)
			continue

		RN.make_active()
