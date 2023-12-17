#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;

init()
{
	if (!maps\mp\zombies\_zm_weapons::is_weapon_included("slowgun_zm"))
		return;

	registerclientfield("actor", "slowgun_fx", 12000, 3, "int");
	registerclientfield("actor", "anim_rate", 7000, 5, "float");
	registerclientfield("allplayers", "anim_rate", 7000, 5, "float");
	registerclientfield("toplayer", "sndParalyzerLoop", 12000, 1, "int");
	registerclientfield("toplayer", "slowgun_fx", 12000, 1, "int");
	level.sliquifier_distance_checks = 0;
	maps\mp\zombies\_zm_spawner::add_cusom_zombie_spawn_logic(::slowgun_on_zombie_spawned);
	maps\mp\zombies\_zm_spawner::register_zombie_damage_callback(::slowgun_zombie_damage_response);
	maps\mp\zombies\_zm_spawner::register_zombie_death_animscript_callback(::slowgun_zombie_death_response);
	level._effect["zombie_slowgun_explosion"] = loadfx("weapon/paralyzer/fx_paralyzer_body_disintegrate");
	level._effect["zombie_slowgun_explosion_ug"] = loadfx("weapon/paralyzer/fx_paralyzer_body_disintegrate_ug");
	level._effect["zombie_slowgun_sizzle"] = loadfx("weapon/paralyzer/fx_paralyzer_hit_dmg");
	level._effect["zombie_slowgun_sizzle_ug"] = loadfx("weapon/paralyzer/fx_paralyzer_hit_dmg_ug");
	level._effect["player_slowgun_sizzle"] = loadfx("weapon/paralyzer/fx_paralyzer_hit_noharm");
	level._effect["player_slowgun_sizzle_ug"] = loadfx("weapon/paralyzer/fx_paralyzer_hit_noharm");
	level._effect["player_slowgun_sizzle_1st"] = loadfx("weapon/paralyzer/fx_paralyzer_hit_noharm_view");
	onplayerconnect_callback(::slowgun_player_connect);
	level.slowgun_damage = 40;
	level.slowgun_damage_ug = 60;
	level.slowgun_damage_mod = "MOD_PROJECTILE_SPLASH";
	precacherumble("damage_heavy");
}

slowgun_on_zombie_spawned()
{
	self set_anim_rate(1.0);
	self.paralyzer_hit_callback = ::zombie_paralyzed;
	self.paralyzer_damaged_multiplier = 1;
	self.paralyzer_score_time_ms = gettime();
	self.paralyzer_slowtime = 0;
	self setclientfield("slowgun_fx", 0);
}

zombie_paralyzed(player, upgraded)
{
	if (!can_be_paralyzed(self))
		return;

	insta = player maps\mp\zombies\_zm_powerups::is_insta_kill_active();

	if (upgraded)
		self setclientfield("slowgun_fx", 5);
	else
		self setclientfield("slowgun_fx", 1);

	if (self.slowgun_anim_rate <= 0.1 || insta && self.slowgun_anim_rate <= 0.5)
	{
		if (upgraded)
			damage = level.slowgun_damage_ug;
		else
			damage = level.slowgun_damage;

		damage *= randomfloatrange(0.667, 1.5);
		damage *= self.paralyzer_damaged_multiplier;

		if (!isdefined(self.paralyzer_damage))
			self.paralyzer_damage = 0;

		// if ( self.paralyzer_damage > 47073 )
		//     damage *= 47073 / self.paralyzer_damage;

		self.paralyzer_damage += damage;

		if (insta)
			damage = self.health + 666;

		if (isalive(self))
			self dodamage(damage, player.origin, player, player, "none", level.slowgun_damage_mod, 0, "slowgun_zm");

		self.paralyzer_damaged_multiplier *= 1.15;
		self.paralyzer_damaged_multiplier = min(self.paralyzer_damaged_multiplier, 50);
	}
	else
		self.paralyzer_damaged_multiplier = 1;

	self zombie_slow_for_time(0.2);
}

player_slow_for_time(time)
{
	self notify("player_slow_for_time");
	self endon("player_slow_for_time");
	self endon("disconnect");

	if (!is_true(self.slowgun_flying))
		self thread player_fly_rumble();

	self setclientfieldtoplayer("slowgun_fx", 1);
	self set_anim_rate(0.2);

	wait(time);

	self set_anim_rate(1.0);
	self setclientfieldtoplayer("slowgun_fx", 0);
	self.slowgun_flying = 0;
}

watch_reset_anim_rate()
{
	self set_anim_rate(1);
	self setclientfieldtoplayer("slowgun_fx", 0);

	while (1)
	{
		self waittill_any("spawned_player", "entering_last_stand", "player_revived", "player_suicide");
		self setclientfieldtoplayer("slowgun_fx", 0);
		self set_anim_rate(1);
	}
}