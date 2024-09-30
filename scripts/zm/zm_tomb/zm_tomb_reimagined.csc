#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_tomb_capture_zones::register_perk_machine_smoke_struct_references, scripts\zm\replaced\zm_tomb_capture_zones::register_perk_machine_smoke_struct_references);
	replaceFunc(clientscripts\mp\zm_tomb_craftables::register_clientfields, scripts\zm\replaced\zm_tomb_craftables::register_clientfields);
	replaceFunc(clientscripts\mp\zombies\_zm_ai_mechz::mechzfootstepcbfunc, scripts\zm\replaced\_zm_ai_mechz::mechzfootstepcbfunc);
}

init()
{
	level thread init_custom_perk_machine_smoke_structs();
}

init_custom_perk_machine_smoke_structs()
{
	waitrealtime(0.05);

	custom_perk_machine_ents = get_custom_perk_machine_ents();
	ents = getentarray(0);

	foreach (ent in ents)
	{
		if (isdefined(ent.model) && ent.model == "p6_zm_tm_vending_pipes")
		{
			perk_machine_ent = get_array_of_closest(ent.origin, custom_perk_machine_ents)[0];
			targetname = get_targetname_from_perk_machine_ent(perk_machine_ent);

			struct = spawnstruct();
			struct.origin = ent.origin + anglestoforward(ent.angles) * -12 + anglestoright(ent.angles) * -4 + anglestoup(ent.angles) * 78;
			struct.angles = ent.angles;
			struct.targetname = targetname;
			struct.classname = "script_struct";

			level.struct_class_names["targetname"][targetname] = array(struct);
		}
	}
}

get_custom_perk_machine_ents()
{
	custom_perk_machine_ents = [];
	ents = getentarray(0);

	foreach (ent in ents)
	{
		if (!isdefined(ent.model))
		{
			continue;
		}

		if (ent.model == "zombie_vending_doubletap2" || ent.model == "zombie_vending_doubletap2_on" || ent.model == "p6_zm_al_vending_ads_on")
		{
			custom_perk_machine_ents[custom_perk_machine_ents.size] = ent;
		}
	}

	return custom_perk_machine_ents;
}

get_targetname_from_perk_machine_ent(ent)
{
	switch (ent.model)
	{
		case "zombie_vending_doubletap2":
		case "zombie_vending_doubletap2_on":
			return "doubletap_pipes";

		case "p6_zm_al_vending_ads_on":
			return "deadshot_pipes";

		default:
			return "";
	}
}