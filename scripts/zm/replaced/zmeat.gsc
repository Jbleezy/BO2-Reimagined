#include maps\mp\gametypes_zm\zmeat;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module_meat_utility;

create_item_meat_watcher()
{
	watcher = self maps\mp\gametypes_zm\_weaponobjects::createuseweaponobjectwatcher("item_meat", get_gamemode_var("item_meat_name"), self.team);
	watcher.pickup = ::item_meat_on_pickup;
	watcher.onspawn = ::item_meat_spawned;
	watcher.onspawnretrievetriggers = ::play_item_meat_on_spawn_retrieve_trigger;
	watcher.headicon = 0;
}

play_item_meat_on_spawn_retrieve_trigger(watcher, player)
{
	self item_meat_on_spawn_retrieve_trigger(watcher, player, get_gamemode_var("item_meat_name"));
}

item_meat_on_spawn_retrieve_trigger(watcher, player, weaponname)
{
	self endon("death");
	add_meat_event("meat_spawn", self);

	while (isdefined(level.splitting_meat) && level.splitting_meat)
	{
		wait 0.15;
	}

	if (isdefined(player))
	{
		self setowner(player);
		self setteam(player.pers["team"]);
		self.owner = player;
		self.oldangles = self.angles;

		if (is_player_valid(player))
		{
			player.statusicon = "";
		}

		if (player hasweapon(weaponname))
		{
			if (!(isdefined(self._fake_meat) && self._fake_meat))
			{
				player thread player_wait_take_meat(weaponname);
			}
			else
			{
				player takeweapon(weaponname);
				player decrement_is_drinking();
			}
		}

		if (!(isdefined(self._fake_meat) && self._fake_meat))
		{
			if (!(isdefined(self._respawned_meat) && self._respawned_meat))
			{
				level notify("meat_thrown", player);
				level._last_person_to_throw_meat = player;
				level._last_person_to_throw_meat_time = gettime();
			}
		}
	}

	level.meat_player = undefined;

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		if (isDefined(player.head_icon))
		{
			player.head_icon.alpha = 1;
		}

		player thread [[level.show_grief_hud_msg_func]](&"");
	}

	players = get_players();

	foreach (other_player in players)
	{
		other_player thread maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup();

		if (is_player_valid(other_player) && !is_true(other_player.spawn_protection) && !is_true(other_player.revive_protection))
		{
			other_player.ignoreme = 0;
		}

		other_player thread scripts\zm\replaced\zgrief::print_meat_msg(player, "dropped");
	}

	if (!(isdefined(self._fake_meat) && self._fake_meat))
	{
		level._meat_moving = 1;

		if (isdefined(level.item_meat) && level.item_meat != self)
		{
			level.item_meat cleanup_meat();
		}

		level.item_meat = self;
	}

	self thread item_meat_watch_stationary();
	self thread item_meat_watch_bounce();
	self.item_meat_pick_up_trigger = spawn("trigger_radius_use", self.origin, 0, 36, 72);
	self.item_meat_pick_up_trigger setcursorhint("HINT_NOICON");
	self.item_meat_pick_up_trigger sethintstring(&"ZOMBIE_MEAT_PICKUP");
	self.item_meat_pick_up_trigger enablelinkto();
	self.item_meat_pick_up_trigger linkto(self);
	self.item_meat_pick_up_trigger triggerignoreteam();
	level.item_meat_pick_up_trigger = self.item_meat_pick_up_trigger;
	self thread item_meat_watch_below();
	self thread item_meat_watch_shutdown();
	self.meat_id = indexinarray(level._fake_meats, self);

	if (!isdefined(self.meat_id))
	{
		self.meat_id = 0;
	}

	if (isdefined(level.dont_allow_meat_interaction) && level.dont_allow_meat_interaction)
	{
		self.item_meat_pick_up_trigger setinvisibletoall();
	}

	self._respawned_meat = undefined;
}

item_meat_watch_bounce()
{
	self endon("death");
	self endon("picked_up");
	self.meat_is_flying = 1;
	self.bounce_count = 0;

	while (1)
	{
		self waittill("grenade_bounce", pos, normal, ent);

		if (isdefined(level.meat_bounce_override))
		{
			self thread [[level.meat_bounce_override]](pos, normal, ent, true);
		}
	}

	self.meat_is_flying = 0;
}

item_meat_watch_stationary()
{
	self endon("death");
	self endon("picked_up");
	self.meat_is_moving = 1;

	self waittill("stationary", pos, normal);

	if (isdefined(level.meat_bounce_override))
	{
		self thread [[level.meat_bounce_override]](pos, normal, undefined, false);
	}

	self.meat_is_moving = 0;

	self delete();
}

item_meat_watch_below()
{
	self endon("death");
	self endon("picked_up");

	og_origin = self.origin;

	while ((self.origin[2] - og_origin[2]) > -1000)
	{
		wait 0.05;
	}

	if (isdefined(level.meat_bounce_override))
	{
		self thread [[level.meat_bounce_override]](self.origin, undefined, undefined, false);
	}

	self delete();
}

player_wait_take_meat(meat_name)
{
	self.dont_touch_the_meat = 1;

	if (isdefined(self.pre_temp_weapon) && self hasweapon(self.pre_temp_weapon))
	{
		self switchtoweapon(self.pre_temp_weapon);
	}
	else if (isdefined(self.last_held_primary_weapon) && self hasweapon(self.last_held_primary_weapon))
	{
		self switchtoweapon(self.last_held_primary_weapon);
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();

		if (isdefined(primaryweapons) && primaryweapons.size > 0)
		{
			self switchtoweapon(primaryweapons[0]);
		}
		else
		{
			assert(0, "Player has no weapon");
			self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
		}
	}

	self waittill_notify_or_timeout("weapon_change", 3);

	self takeweapon(meat_name);

	if (self.is_drinking)
	{
		self decrement_is_drinking();
	}

	if (!self.is_drinking)
	{
		self.pre_temp_weapon = undefined;
	}

	self.dont_touch_the_meat = 0;
}