#include clientscripts\mp\zombies\_zm_perk_vulture;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zombies\_zm_perks;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\_filter;

init_vulture()
{
	registerclientfield("toplayer", "vulture_perk_toplayer", 12000, 1, "int", ::vulture_callback_toplayer, 0, 1);
	registerclientfield("actor", "vulture_perk_actor", 12000, 2, "int", ::vulture_callback_actor, 0, 0);
	registerclientfield("scriptmover", "vulture_perk_scriptmover", 12000, 4, "int", ::vulture_callback_scriptmover, 0, 0);
	registerclientfield("zbarrier", "vulture_perk_zbarrier", 12000, 1, "int", ::vulture_vision_mystery_box, 0, 0);
	registerclientfield("toplayer", "sndVultureStink", 12000, 1, "int", ::sndvulturestink);
	registerclientfield("world", "vulture_perk_disable_solo_quick_revive_glow", 12000, 1, "int", ::vulture_disable_solo_quick_revive_glow, 0, 0);
	registerclientfield("toplayer", "vulture_perk_disease_meter", 12000, 5, "float", ::vulture_callback_stink_active, 0, 1);
	registerclientfield("toplayer", "vulture_perk_ir", 3000, 1, "int", ::vulture_perk_ir, 0, 1);
	setupclientfieldcodecallbacks("toplayer", 1, "vulture_perk_disease_meter");
	clientscripts\mp\_visionset_mgr::vsmgr_register_overlay_info_style_filter("vulture_stink_overlay", 12000, 31, 0, 0, "generic_filter_zombie_perk_vulture", 0);
	level._effect["vulture_perk_zombie_stink"] = loadfx("maps/zombie/fx_zm_vulture_perk_stink");
	level._effect["vulture_perk_zombie_stink_trail"] = loadfx("maps/zombie/fx_zm_vulture_perk_stink_trail");
	level._effect["vulture_perk_bonus_drop"] = loadfx("misc/fx_zombie_powerup_vulture");
	level._effect["vulture_drop_picked_up"] = loadfx("misc/fx_zombie_powerup_grab");
	level._effect["vulture_perk_wallbuy_static"] = loadfx("maps/zombie/fx_zm_vulture_wallbuy_rifle");
	level._effect["vulture_perk_wallbuy_dynamic"] = loadfx("maps/zombie/fx_zm_vulture_glow_question");
	level._effect["vulture_perk_machine_glow_doubletap"] = loadfx("maps/zombie/fx_zm_vulture_glow_dbltap");
	level._effect["vulture_perk_machine_glow_juggernog"] = loadfx("maps/zombie/fx_zm_vulture_glow_jugg");
	level._effect["vulture_perk_machine_glow_revive"] = loadfx("maps/zombie/fx_zm_vulture_glow_revive");
	level._effect["vulture_perk_machine_glow_speed"] = loadfx("maps/zombie/fx_zm_vulture_glow_speed");
	level._effect["vulture_perk_machine_glow_marathon"] = loadfx("maps/zombie/fx_zm_vulture_glow_marathon");
	level._effect["vulture_perk_machine_glow_mule_kick"] = loadfx("maps/zombie/fx_zm_vulture_glow_mule");
	level._effect["vulture_perk_machine_glow_pack_a_punch"] = loadfx("maps/zombie/fx_zm_vulture_glow_pap");
	level._effect["vulture_perk_machine_glow_vulture"] = loadfx("maps/zombie/fx_zm_vulture_glow_vulture");
	level._effect["vulture_perk_mystery_box_glow"] = loadfx("maps/zombie/fx_zm_vulture_glow_mystery_box");
	level._effect["vulture_perk_powerup_drop"] = loadfx("maps/zombie/fx_zm_vulture_glow_powerup");
	level._effect["vulture_perk_zombie_eye_glow"] = loadfx("misc/fx_zombie_eye_vulture");
	level.perk_vulture = spawnstruct();
	level.perk_vulture.array_stink_zombies = [];
	level.perk_vulture.array_stink_drop_locations = [];
	level.perk_vulture.players_with_vulture_perk = [];
	level.perk_vulture.vulture_vision_fx_list = [];
	level.perk_vulture.clientfields = spawnstruct();
	level.perk_vulture.clientfields.scriptmovers = [];
	level.perk_vulture.clientfields.scriptmovers[0] = ::vulture_stink_fx;
	level.perk_vulture.clientfields.scriptmovers[1] = ::vulture_drop_fx;
	level.perk_vulture.clientfields.scriptmovers[2] = ::vulture_drop_pickup;
	level.perk_vulture.clientfields.scriptmovers[3] = ::vulture_powerup_drop;
	level.perk_vulture.clientfields.actors = [];
	level.perk_vulture.clientfields.actors[1] = ::vulture_eye_glow;
	level.perk_vulture.clientfields.actors[0] = ::vulture_stink_trail_fx;
	level.perk_vulture.clientfields.toplayer = [];
	level.perk_vulture.clientfields.toplayer[0] = ::vulture_toggle;
	level.perk_vulture.disable_solo_quick_revive_glow = 0;

	if (!isdefined(level.perk_vulture.custom_funcs_enable))
	{
		level.perk_vulture.custom_funcs_enable = [];
	}

	if (!isdefined(level.perk_vulture.custom_funcs_disable))
	{
		level.perk_vulture.custom_funcs_disable = [];
	}

	level.zombie_eyes_clientfield_cb_additional = ::vulture_eye_glow_callback_from_system;
}

vulture_perk_ir(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if (!self islocalplayer())
	{
		return;
	}

	if (!isdefined(self getlocalclientnumber()))
	{
		return;
	}

	if (self getlocalclientnumber() != localclientnum)
	{
		return;
	}

	if (isdemoplaying() && isspectating(localclientnum))
	{
		newval = 0;
	}

	vulture_perk_set_ir(localclientnum, newval);
}

vulture_perk_set_ir(lcn, newval)
{
	if (newval)
	{
		setlutscriptindex(lcn, 2);
		enable_filter_zm_turned(self, 0, 0);
		self setsonarattachmentenabled(1);
	}
	else
	{
		setlutscriptindex(lcn, 0);
		disable_filter_zm_turned(self, 0, 0);
		self setsonarattachmentenabled(0);
	}
}

vulture_vision_enable(localclientnumber)
{
	if (isdefined(level.perk_vulture.vulture_vision_fx_list[localclientnumber]))
	{
		vulture_vision_disable(localclientnumber);
	}

	level.perk_vulture.vulture_vision_fx_list[localclientnumber] = spawnstruct();
	s_temp = level.perk_vulture.vulture_vision_fx_list[localclientnumber];
	s_temp.player_ent = self;
	s_temp.fx_list = [];
	s_temp.fx_list_wallbuy = [];
	s_temp.fx_list_special = [];

	foreach (powerup in level.perk_vulture.vulture_vision.powerups)
	{
		powerup _powerup_drop_fx_enable(localclientnumber);
	}

	foreach (zombie in level.perk_vulture.vulture_vision.actors_eye_glow)
	{
		zombie _zombie_eye_glow_enable(localclientnumber);
	}

	self.perk_vulture = s_temp;
	level.perk_vulture.fx_array[localclientnumber] = s_temp;
}

vulture_vision_update_wallbuy_list(localclientnumber, b_first_run)
{
	// removed
}

vulture_vision_mystery_box(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	// removed
}