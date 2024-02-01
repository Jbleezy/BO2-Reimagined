#include maps\mp\zm_buried_gamemodes;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_buried;
#include maps\mp\zm_buried_classic;
#include maps\mp\zm_buried_turned_street;
#include maps\mp\zm_buried_grief_street;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_unitrigger;

init()
{
	add_map_gamemode("zclassic", maps\mp\zm_buried::zclassic_preinit, undefined, undefined);
	add_map_gamemode("zstandard", ::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zgrief", maps\mp\zm_buried::zgrief_preinit, undefined, undefined);
	add_map_gamemode("zcleansed", maps\mp\zm_buried::zcleansed_preinit, undefined, undefined);

	add_map_location_gamemode("zclassic", "processing", maps\mp\zm_buried_classic::precache, maps\mp\zm_buried_classic::main);

	add_map_location_gamemode("zstandard", "street", scripts\zm\replaced\zm_buried_grief_street::precache, scripts\zm\replaced\zm_buried_grief_street::main);
	add_map_location_gamemode("zstandard", "maze", scripts\zm\locs\zm_buried_loc_maze::precache, scripts\zm\locs\zm_buried_loc_maze::main);

	add_map_location_gamemode("zgrief", "street", scripts\zm\replaced\zm_buried_grief_street::precache, scripts\zm\replaced\zm_buried_grief_street::main);
	add_map_location_gamemode("zgrief", "maze", scripts\zm\locs\zm_buried_loc_maze::precache, scripts\zm\locs\zm_buried_loc_maze::main);

	add_map_location_gamemode("zcleansed", "street", maps\mp\zm_buried_turned_street::precache, maps\mp\zm_buried_turned_street::main);

	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "maze", scripts\zm\locs\zm_buried_loc_maze::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "maze", scripts\zm\locs\zm_buried_loc_maze::struct_init);
}

zstandard_preinit()
{
	survival_init();
}

survival_init()
{
	level.force_team_characters = 1;
	level.should_use_cia = 0;

	if (randomint(100) > 50)
		level.should_use_cia = 1;

	level.precachecustomcharacters = ::precache_team_characters;
	level.givecustomcharacters = ::give_team_characters;
	zm_buried_common_init();
	flag_wait("start_zombie_round_logic");
}

give_team_characters()
{
	self detachall();
	self set_player_is_female(0);

	if (isdefined(level.should_use_cia))
	{
		if (level.should_use_cia)
		{
			self setmodel("c_zom_player_cia_dlc1_fb");
			self setviewmodel("c_zom_suit_viewhands");
			self.characterindex = 0;
		}
		else
		{
			self setmodel("c_zom_player_cdc_dlc1_fb");
			self setviewmodel("c_zom_hazmat_viewhands");
			self.characterindex = 1;
		}
	}
	else
	{
		if (!isdefined(self.characterindex))
		{
			self.characterindex = 1;

			if (self.team == "axis")
				self.characterindex = 0;
		}

		switch (self.characterindex)
		{
			case 0:
			case 2:
				self setmodel("c_zom_player_cia_dlc1_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_suit_viewhands");
				self.characterindex = 0;
				break;

			case 1:
			case 3:
				self setmodel("c_zom_player_cdc_dlc1_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_hazmat_viewhands");
				self.characterindex = 1;
				break;
		}
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

buildbuildable(buildable)
{
	player = get_players()[0];

	foreach (stub in level.buildable_stubs)
	{
		if (!isdefined(buildable) || stub.equipname == buildable)
		{
			if (isdefined(buildable) || stub.persistent != 3)
			{
				stub maps\mp\zombies\_zm_buildables::buildablestub_remove();

				foreach (piece in stub.buildablezone.pieces)
				{
					piece maps\mp\zombies\_zm_buildables::piece_unspawn();
				}

				stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build(player);

				stub.model notsolid();
				stub.model show();

				return;
			}
		}
	}
}