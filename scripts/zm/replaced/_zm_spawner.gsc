#include maps\mp\zombies\_zm_spawner;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

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

	if ( self maps\mp\zombies\_zm_spawner::check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount ) )
	{
		return;
	}
	else if ( self maps\mp\zombies\_zm_spawner::zombie_flame_damage( mod, player ) )
	{
		if ( self maps\mp\zombies\_zm_spawner::zombie_give_flame_damage_points() )
		{
			player maps\mp\zombies\_zm_score::player_add_points( "damage", mod, hit_location, self.isdog, team );
		}
	}
	else if ( maps\mp\zombies\_zm_spawner::player_using_hi_score_weapon( player ) )
	{
		damage_type = "damage";
	}
	else
	{
		damage_type = "damage_light";
	}

	if ( !is_true( self.no_damage_points ) )
	{
		player maps\mp\zombies\_zm_score::player_add_points( damage_type, mod, hit_location, self.isdog, team, self.damageweapon );
	}

	if ( isDefined( self.zombie_damage_fx_func ) )
	{
		self [[ self.zombie_damage_fx_func ]]( mod, hit_location, hit_origin, player );
	}

	if ( is_placeable_mine( self.damageweapon ) )
	{
		damage = level.round_number * 100;
		if(level.scr_zm_ui_gametype == "zgrief")
		{
			damage = 2000;
		}

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
			self dodamage( damage, self.origin, player, self, hit_location, mod, 0, self.damageweapon );
		}
		else
		{
			self dodamage( damage, self.origin, undefined, self, hit_location, mod, 0, self.damageweapon );
		}
	}
	else if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
	{
		damage = level.round_number * 25;
		if(level.scr_zm_ui_gametype == "zgrief")
		{
			damage = 500;
		}

        max_damage = 1500;
        if(damage > max_damage)
        {
            damage = max_damage;
        }

		if ( isDefined( player ) && isalive( player ) )
		{
			player.grenade_multiattack_count++;
			player.grenade_multiattack_ent = self;
			self dodamage( damage, self.origin, player, self, hit_location, "MOD_GRENADE_SPLASH", 0, self.damageweapon );
		}
		else
		{
			self dodamage( damage, self.origin, undefined, self, hit_location, "MOD_GRENADE_SPLASH", 0, self.damageweapon );
		}
	}
	else if ( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
	{
		damage = level.round_number * 50;
		if(level.scr_zm_ui_gametype == "zgrief")
		{
			damage = 1000;
		}

        max_damage = 3000;
        if(damage > max_damage)
        {
            damage = max_damage;
        }

		if ( isDefined( player ) && isalive( player ) )
		{
			self dodamage( damage, self.origin, player, self, hit_location, "MOD_PROJECTILE_SPLASH", 0, self.damageweapon );
		}
		else
		{
			self dodamage( damage, self.origin, undefined, self, hit_location, "MOD_PROJECTILE_SPLASH", 0, self.damageweapon );
		}
	}

	if ( isDefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" && isalive( self ) )
	{
		if ( isDefined( player ) )
		{
			rand = randomintrange( 0, 100 );
			if ( rand < 10 )
			{
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "crawl_spawn" );
			}
		}
	}
	else if ( isDefined( self.a.gib_ref ) )
	{
		if ( self.a.gib_ref == "right_arm" || self.a.gib_ref == "left_arm" )
		{
			if ( self.has_legs && isalive( self ) )
			{
				if ( isDefined( player ) )
				{
					rand = randomintrange( 0, 100 );
					if ( rand < 7 )
					{
						player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "shoot_arm" );
					}
				}
			}
		}
	}

	self thread maps\mp\zombies\_zm_powerups::check_for_instakill( player, mod, hit_location );
}

zombie_gib_on_damage()
{
    while ( true )
    {
        self waittill( "damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weaponname );

        if ( !isdefined( self ) )
            return;

        if ( !self zombie_should_gib( amount, attacker, type ) )
            continue;

        if ( self head_should_gib( attacker, type, point ) && type != "MOD_BURNED" )
        {
            self zombie_head_gib( attacker, type );
            continue;
        }

        if ( !self.gibbed )
        {
            if ( self maps\mp\animscripts\zm_utility::damagelocationisany( "head", "helmet", "neck" ) )
                continue;

            refs = [];

            switch ( self.damagelocation )
            {
                case "torso_upper":
                case "torso_lower":
                    refs[refs.size] = "guts";
                    refs[refs.size] = "right_arm";
                    break;
                case "right_hand":
                case "right_arm_upper":
                case "right_arm_lower":
                    refs[refs.size] = "right_arm";
                    break;
                case "left_hand":
                case "left_arm_upper":
                case "left_arm_lower":
                    refs[refs.size] = "left_arm";
                    break;
                case "right_leg_upper":
                case "right_leg_lower":
                case "right_foot":
                    if ( self.health <= 0 )
                    {
                        refs[refs.size] = "right_leg";
                        refs[refs.size] = "right_leg";
                        refs[refs.size] = "right_leg";
                        refs[refs.size] = "no_legs";
                    }

                    break;
                case "left_leg_upper":
                case "left_leg_lower":
                case "left_foot":
                    if ( self.health <= 0 )
                    {
                        refs[refs.size] = "left_leg";
                        refs[refs.size] = "left_leg";
                        refs[refs.size] = "left_leg";
                        refs[refs.size] = "no_legs";
                    }

                    break;
                default:
                    if ( self.damagelocation == "none" )
                    {
                        if ( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
                        {
                            refs = self derive_damage_refs( point );
                            break;
                        }
                    }
                    else
                    {
                        refs[refs.size] = "guts";
                        refs[refs.size] = "right_arm";
                        refs[refs.size] = "left_arm";
                        refs[refs.size] = "right_leg";
                        refs[refs.size] = "left_leg";
                        refs[refs.size] = "no_legs";
                        break;
                    }
            }

            if ( isdefined( level.custom_derive_damage_refs ) )
                refs = self [[ level.custom_derive_damage_refs ]]( refs, point, weaponname );

            if ( refs.size )
            {
                self.a.gib_ref = maps\mp\animscripts\zm_death::get_random( refs );

                if ( ( self.a.gib_ref == "no_legs" || self.a.gib_ref == "right_leg" || self.a.gib_ref == "left_leg" ) && self.health > 0 )
                {
                    self.has_legs = 0;
                    self allowedstances( "crouch" );
                    self setphysparams( 15, 0, 24 );
                    self allowpitchangle( 1 );
                    self setpitchorient();
                    health = self.health;
                    health *= 0.1;
                    self thread maps\mp\animscripts\zm_run::needsdelayedupdate();

					if (level.scr_zm_ui_gametype == "zgrief")
					{
						self thread bleedout_watcher();
					}

                    if ( isdefined( self.crawl_anim_override ) )
                        self [[ self.crawl_anim_override ]]();
                }
            }

            if ( self.health > 0 )
            {
                self thread maps\mp\animscripts\zm_death::do_gib();

                if ( isdefined( level.gib_on_damage ) )
                    self thread [[ level.gib_on_damage ]]();
            }
        }
    }
}

bleedout_watcher()
{
	self endon("death");

	self thread melee_watcher();

	self.bleedout_time = getTime();
	health = self.health;

	while (1)
	{
		if (health > self.health)
		{
			health = self.health;
			self.bleedout_time = getTime();
		}

		if (getTime() - self.bleedout_time > 30000)
		{
			level.zombie_total++;
			self.no_powerups = 1;
			self dodamage(self.health + 100, self.origin);
			return;
		}

		wait 0.05;
	}
}

melee_watcher()
{
	self endon("death");

	while (1)
	{
		self waittill("melee_anim");

		self.bleedout_time = getTime();
	}
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

	if ( !self maps\mp\animscripts\zm_utility::damagelocationisany( "head", "helmet", "neck" ) )
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

zombie_can_drop_powerups( zombie )
{
    if ( !flag( "zombie_drop_powerups" ) )
        return false;

    if ( isdefined( zombie.no_powerups ) && zombie.no_powerups )
        return false;

    return true;
}

zombie_complete_emerging_into_playable_area()
{
	if (self.animname == "zombie")
	{
		self setphysparams( 15, 0, 60 );
	}

    self.completed_emerging_into_playable_area = 1;
    self notify( "completed_emerging_into_playable_area" );
    self.no_powerups = 0;
    self thread zombie_free_cam_allowed();
}