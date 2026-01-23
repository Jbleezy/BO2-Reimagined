#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zm_highrise;
#include maps\mp\zm_highrise_classic;

init()
{
	add_map_gamemode("zclassic", maps\mp\zm_highrise::zclassic_preinit, undefined, undefined);
	add_map_gamemode("zstandard", ::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zgrief", ::zstandard_preinit, undefined, undefined);

	add_map_location_gamemode("zclassic", "rooftop", maps\mp\zm_highrise_classic::precache, maps\mp\zm_highrise_classic::main);

	add_map_location_gamemode("zstandard", "shopping_mall", scripts\zm\locs\zm_highrise_loc_shopping_mall::precache, scripts\zm\locs\zm_highrise_loc_shopping_mall::main);
	add_map_location_gamemode("zstandard", "dragon_rooftop", scripts\zm\locs\zm_highrise_loc_dragon_rooftop::precache, scripts\zm\locs\zm_highrise_loc_dragon_rooftop::main);
	add_map_location_gamemode("zstandard", "sweatshop", scripts\zm\locs\zm_highrise_loc_sweatshop::precache, scripts\zm\locs\zm_highrise_loc_sweatshop::main);

	add_map_location_gamemode("zgrief", "shopping_mall", scripts\zm\locs\zm_highrise_loc_shopping_mall::precache, scripts\zm\locs\zm_highrise_loc_shopping_mall::main);
	add_map_location_gamemode("zgrief", "dragon_rooftop", scripts\zm\locs\zm_highrise_loc_dragon_rooftop::precache, scripts\zm\locs\zm_highrise_loc_dragon_rooftop::main);
	add_map_location_gamemode("zgrief", "sweatshop", scripts\zm\locs\zm_highrise_loc_sweatshop::precache, scripts\zm\locs\zm_highrise_loc_sweatshop::main);

	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "shopping_mall", scripts\zm\locs\zm_highrise_loc_shopping_mall::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "shopping_mall", scripts\zm\locs\zm_highrise_loc_shopping_mall::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "dragon_rooftop", scripts\zm\locs\zm_highrise_loc_dragon_rooftop::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "dragon_rooftop", scripts\zm\locs\zm_highrise_loc_dragon_rooftop::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "sweatshop", scripts\zm\locs\zm_highrise_loc_sweatshop::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "sweatshop", scripts\zm\locs\zm_highrise_loc_sweatshop::struct_init);
}

zstandard_preinit()
{
	survival_init();
}

survival_init()
{
	if (is_gametype_active("zstandard"))
	{
		level.force_team_characters = 1;
		level.should_use_cia = 0;

		if (randomint(100) >= 50)
		{
			level.should_use_cia = 1;
		}
	}

	level.precachecustomcharacters = ::precache_team_characters;
	level.givecustomcharacters = ::give_team_characters;
}

precache_team_characters()
{
	precachemodel("c_zom_player_cdc_dlc1_fb");
	precachemodel("c_zom_hazmat_viewhands");
	precachemodel("c_zom_player_cia_dlc1_fb");
	precachemodel("c_zom_suit_viewhands");
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
			{
				self.characterindex = 0;
			}
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