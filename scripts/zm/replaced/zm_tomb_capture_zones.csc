#include clientscripts\mp\zm_tomb_capture_zones;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_music;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_fx;

#using_animtree("fxanim_props_dlc4");

register_perk_machine_smoke_struct_references()
{
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_1", "revive_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_2", "deadshot_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_3", "speedcola_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_4", "jugg_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_5", "staminup_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_6", "doubletap_pipes");
}

get_pack_a_punch_model(localclientnumber)
{
	if (!isdefined(level.pack_a_punch_model))
	{
		level.pack_a_punch_model = [];
	}

	if (!isdefined(level.pack_a_punch_model[localclientnumber]))
	{
		pap_targetnames = array("pap_cs", "pap_cs_trenches");
		valid_pap_targetname = "pap_cs";

		if (getdvar("ui_zm_mapstartlocation") == "trenches")
		{
			valid_pap_targetname = "pap_cs_trenches";
		}

		level.pack_a_punch_model[localclientnumber] = getent(localclientnumber, valid_pap_targetname, "targetname");

		if (getdvar("g_gametype") == "zgrief" && getdvarintdefault("ui_gametype_pro", 0))
		{
			level.pack_a_punch_model[localclientnumber] hide();
		}

		foreach (pap_targetname in pap_targetnames)
		{
			if (pap_targetname == valid_pap_targetname)
			{
				continue;
			}

			other_pack_a_punch_model = getent(localclientnumber, pap_targetname, "targetname");
			other_pack_a_punch_model delete();
		}
	}

	level.pack_a_punch_model[localclientnumber] waittill_dobj(localclientnumber);

	if (!level.pack_a_punch_model[localclientnumber] hasanimtree())
	{
		level.pack_a_punch_model[localclientnumber] useanimtree(#animtree );
		level.pack_a_punch_model[localclientnumber] mapshaderconstant(localclientnumber, 2, "ScriptVector0", 1);
	}

	return level.pack_a_punch_model[localclientnumber];
}