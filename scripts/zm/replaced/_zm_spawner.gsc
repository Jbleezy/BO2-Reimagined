#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_spawner;

zombie_damage( mod, hit_location, hit_origin, player, amount, team )
{
	if ( is_magic_bullet_shield_enabled( self ) )
	{
		return;
	}

	player.use_weapon_type = mod;

	if ( isDefined( self.marked_for_death ) )
	{
		return;
	}

	if ( !isDefined( player ) )
	{
		return;
	}

	if ( isDefined( hit_origin ) )
	{
		self.damagehit_origin = hit_origin;
	}
	else
	{
		self.damagehit_origin = player getweaponmuzzlepoint();
	}

	if ( self maps/mp/zombies/_zm_spawner::check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount ) )
	{
		return;
	}
	else if ( self maps/mp/zombies/_zm_spawner::zombie_flame_damage( mod, player ) )
	{
		if ( self maps/mp/zombies/_zm_spawner::zombie_give_flame_damage_points() )
		{
			player maps/mp/zombies/_zm_score::player_add_points( "damage", mod, hit_location, self.isdog, team );
		}
	}
	else if ( maps/mp/zombies/_zm_spawner::player_using_hi_score_weapon( player ) )
	{
		damage_type = "damage";
	}
	else
	{
		damage_type = "damage_light";
	}

	if ( !is_true( self.no_damage_points ) )
	{
		player maps/mp/zombies/_zm_score::player_add_points( damage_type, mod, hit_location, self.isdog, team, self.damageweapon );
	}

	if ( isDefined( self.zombie_damage_fx_func ) )
	{
		self [[ self.zombie_damage_fx_func ]]( mod, hit_location, hit_origin, player );
	}

	modname = remove_mod_from_methodofdeath( mod );

    round_scalar = level.round_number;
    if(level.scr_zm_ui_gametype == "zgrief")
	{
        round_scalar = 20;
    }

	if ( is_placeable_mine( self.damageweapon ) )
	{
		damage = round_scalar * 150;
        max_damage = 9000;
        if(damage > max_damage)
        {
            damage = max_damage;
        }

		if ( isDefined( self.zombie_damage_claymore_func ) )
		{
			self [[ self.zombie_damage_claymore_func ]]( mod, hit_location, hit_origin, player );
		}
		else if ( isDefined( player ) && isalive( player ) )
		{
			self dodamage( damage, self.origin, player, self, hit_location, mod );
		}
		else
		{
			self dodamage( damage, self.origin, undefined, self, hit_location, mod );
		}
	}
	else if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
	{
		damage = 150;

		if ( isDefined( player ) && isalive( player ) )
		{
			player.grenade_multiattack_count++;
			player.grenade_multiattack_ent = self;
			self dodamage( damage, self.origin, player, self, hit_location, modname );
		}
		else
		{
			self dodamage( damage, self.origin, undefined, self, hit_location, modname );
		}
	}
	else if ( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
	{
		damage = round_scalar * 50;
        max_damage = 3000;
        if(damage > max_damage)
        {
            damage = max_damage;
        }

		if ( isDefined( player ) && isalive( player ) )
		{
			self dodamage( damage, self.origin, player, self, hit_location, modname );
		}
		else
		{
			self dodamage( damage, self.origin, undefined, self, hit_location, modname );
		}
	}

	if ( isDefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" && isalive( self ) )
	{
		if ( isDefined( player ) )
		{
			rand = randomintrange( 0, 100 );
			if ( rand < 10 )
			{
				player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "crawl_spawn" );
			}
		}
	}
	else if ( isDefined( self.a.gib_ref ) || self.a.gib_ref == "right_arm" && self.a.gib_ref == "left_arm" )
	{
		if ( self.has_legs && isalive( self ) )
		{
			if ( isDefined( player ) )
			{
				rand = randomintrange( 0, 100 );
				if ( rand < 7 )
				{
					player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "shoot_arm" );
				}
			}
		}
	}

	self thread maps/mp/zombies/_zm_powerups::check_for_instakill( player, mod, hit_location );
}

head_should_gib( attacker, type, point )
{
	if ( !is_mature() )
	{
		return 0;
	}

	if ( self.head_gibbed )
	{
		return 0;
	}

	if ( !isDefined( attacker ) || !isplayer( attacker ) )
	{
		return 0;
	}

	weapon = attacker getcurrentweapon();

    if ( type != "MOD_RIFLE_BULLET" && type != "MOD_PISTOL_BULLET" )
    {
        if ( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
        {
            if ( ( distance( point, self gettagorigin( "j_head" ) ) > 55 ) || ( self.health > 0 ) )
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
        else if ( type == "MOD_PROJECTILE" )
        {
            if ( ( distance( point, self gettagorigin( "j_head" ) ) > 10 ) || ( self.health > 0 ) )
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
        else if ( weaponclass( weapon ) != "spread" )
        {
            return 0;
        }
    }

	if ( !self maps/mp/animscripts/zm_utility::damagelocationisany( "head", "helmet", "neck" ) )
	{
		return 0;
	}

	if ( weapon == "none" || weapon == level.start_weapon || weaponisgasweapon( self.weapon ) )
	{
		return 0;
	}

    self zombie_hat_gib( attacker, type );

	if ( self.health > 0 )
	{
		return 0;
	}

	return 1;
}