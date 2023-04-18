#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weap_jetgun;

jetgun_firing()
{
    if ( !isdefined( self.jetsound_ent ) )
    {
        self.jetsound_ent = spawn( "script_origin", self.origin );
        self.jetsound_ent linkto( self, "tag_origin" );
    }

    jetgun_fired = 0;

    if ( self is_jetgun_firing() && jetgun_fired == 0 )
    {
        self.jetsound_ent playloopsound( "wpn_jetgun_effect_plr_loop", 0.8 );
        self.jetsound_ent playsound( "wpn_jetgun_effect_plr_start" );
        self notify( "jgun_snd" );
    }

    while ( self is_jetgun_firing() )
    {
        jetgun_fired = 1;
        self thread jetgun_fired();
        view_pos = self gettagorigin( "tag_flash" );
        view_angles = self gettagangles( "tag_flash" );

        if ( self get_jetgun_engine_direction() < 0 )
            playfx( level._effect["jetgun_smoke_cloud"], view_pos - self getplayerviewheight(), anglestoforward( view_angles ), anglestoup( view_angles ) );
        else
            playfx( level._effect["jetgun_smoke_cloud"], view_pos - self getplayerviewheight(), anglestoforward( view_angles ) * -1, anglestoup( view_angles ) );

        wait 0.25;
    }

    if ( jetgun_fired == 1 )
    {
        self.jetsound_ent stoploopsound( 0.5 );
        self.jetsound_ent playsound( "wpn_jetgun_effect_plr_end" );
        self thread sound_ent_cleanup();
        jetgun_fired = 0;
    }
}

sound_ent_cleanup()
{
    self endon( "jgun_snd" );
    wait 4;

    if ( isdefined( self.jetsound_ent ) )
	{
		self.jetsound_ent delete();
	}
}

is_jetgun_firing()
{
    if(!self attackButtonPressed())
    {
        return 0;
    }

	return abs( self get_jetgun_engine_direction() ) > 0.2;
}

jetgun_check_enemies_in_range( zombie, view_pos, drag_range_squared, gib_range_squared, grind_range_squared, cylinder_radius_squared, forward_view_angles, end_pos, invert )
{
	if ( !isDefined( zombie ) )
	{
		return;
	}
	if ( zombie enemy_killed_by_jetgun() )
	{
		return;
	}
	if ( isDefined( zombie.is_avogadro ) && zombie.is_avogadro )
	{
		return;
	}
	if ( isDefined( zombie.isdog ) && zombie.isdog )
	{
		return;
	}
	if ( isDefined( zombie.isscreecher ) && zombie.isscreecher )
	{
		return;
	}
	if ( isDefined( self.animname ) && self.animname == "quad_zombie" )
	{
		return;
	}
	test_origin = zombie getcentroid();
	test_range_squared = distancesquared( view_pos, test_origin );
	if ( test_range_squared > drag_range_squared )
	{
		zombie jetgun_debug_print( "range", ( 1, 0, 1 ) );
		return;
	}
	normal = vectornormalize( test_origin - view_pos );
	dot = vectordot( forward_view_angles, normal );
	if ( abs( dot ) < 0.7 )
	{
		zombie jetgun_debug_print( "dot", ( 1, 0, 1 ) );
		return;
	}
	radial_origin = pointonsegmentnearesttopoint( view_pos, end_pos, test_origin );
	if ( distancesquared( test_origin, radial_origin ) > cylinder_radius_squared )
	{
		zombie jetgun_debug_print( "cylinder", ( 1, 0, 1 ) );
		return;
	}
	if ( zombie damageconetrace( view_pos, self ) == 0 )
	{
		zombie jetgun_debug_print( "cone", ( 1, 0, 1 ) );
		return;
	}
	if ( test_range_squared < grind_range_squared )
	{
		level.jetgun_fling_enemies[ level.jetgun_fling_enemies.size ] = zombie;
		level.jetgun_grind_enemies[ level.jetgun_grind_enemies.size ] = dot < 0;
	}
	else
	{
        if ( !isDefined( zombie.ai_state ) || zombie.ai_state != "find_flesh" && zombie.ai_state != "zombieMoveOnBus" )
        {
            return;
        }
        if ( isDefined( zombie.in_the_ground ) && zombie.in_the_ground )
        {
            return;
        }

		if ( test_range_squared < drag_range_squared && dot > 0 )
		{
			level.jetgun_drag_enemies[ level.jetgun_drag_enemies.size ] = zombie;
		}
	}
}

jetgun_grind_zombie( player )
{
	player endon( "death" );
	player endon( "disconnect" );
	self endon( "death" );
	if ( !isDefined( self.jetgun_grind ) )
	{
		self.jetgun_grind = 1;
		self notify( "grinding" );
		if ( is_mature() )
		{
			if ( isDefined( level._effect[ "zombie_guts_explosion" ] ) )
			{
				playfx( level._effect[ "zombie_guts_explosion" ], self gettagorigin( "J_SpineLower" ) );
			}
		}
		self.nodeathragdoll = 1;
		self.handle_death_notetracks = ::jetgun_handle_death_notetracks;
        player maps\mp\zombies\_zm_score::add_to_player_score(50 * maps\mp\zombies\_zm_score::get_points_multiplier(player));
		self dodamage( self.health + 666, player.origin, player );
	}
}

handle_overheated_jetgun()
{
	self endon( "disconnect" );
	while ( 1 )
	{
		self waittill( "jetgun_overheated" );

		if ( self getcurrentweapon() == "jetgun_zm" )
		{
            weapon_org = self gettagorigin( "tag_weapon" );

			if ( isDefined( level.explode_overheated_jetgun ) && level.explode_overheated_jetgun )
			{
				self thread maps\mp\zombies\_zm_equipment::equipment_release( "jetgun_zm" );
				pcount = get_players().size;
				pickup_time = 360 / pcount;
				maps\mp\zombies\_zm_buildables::player_explode_buildable( "jetgun_zm", weapon_org, 250, 1, pickup_time );
			}
			else if ( isDefined( level.unbuild_overheated_jetgun ) && level.unbuild_overheated_jetgun )
			{
                self thread maps\mp\zombies\_zm_equipment::equipment_release( "jetgun_zm" );
                maps\mp\zombies\_zm_buildables::unbuild_buildable( "jetgun_zm", 1 );
                self dodamage( 50, weapon_org );
			}
            else if ( isDefined( level.take_overheated_jetgun ) && level.take_overheated_jetgun )
            {
                self thread maps\mp\zombies\_zm_equipment::equipment_release( "jetgun_zm" );
                self dodamage( 50, weapon_org );
            }
            else
            {
                continue;
            }

            self.jetgun_overheating = undefined;
            self.jetgun_heatval = undefined;
            self playsound( "wpn_jetgun_explo" );
		}
	}
}

jetgun_network_choke()
{
	// no choke
}