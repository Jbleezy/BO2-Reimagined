#include maps\mp\zombies\_zm_equip_headchopper;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\animscripts\zm_death;
#include maps\mp\animscripts\zm_run;
#include maps\mp\zombies\_zm_audio;

#using_animtree("zombie_headchopper");

init_anim_slice_times()
{
	level.headchopper_slice_times = [];
	slice_times = getnotetracktimes( %o_zmb_chopper_slice_slow, "slice" );
	retract_times = getnotetracktimes( %o_zmb_chopper_slice_slow, "retract" );
	animlength = getanimlength( %o_zmb_chopper_slice_slow );

	i = 0;
	foreach ( frac in slice_times )
	{
		if ( i != 6 )
		{
			i++;
			continue;
		}

		level.headchopper_slice_times[level.headchopper_slice_times.size] = animlength * frac;
		i++;
	}

	i = 0;
	foreach ( frac in retract_times )
	{
		if ( i == 0 || i == 6 )
		{
			i++;
			continue;
		}

		level.headchopper_slice_times[level.headchopper_slice_times.size] = animlength * frac;
		i++;
	}
}

headchopperthink( weapon, electricradius, armed )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_headchopper_zm_taken" );
	weapon endon( "death" );
	radiussquared = electricradius * electricradius;
	traceposition = weapon getcentroid() + anglestoforward( flat_angle( weapon.angles ) ) * -15;
	trace = bullettrace( traceposition, traceposition + vectorscale( ( 0, 0, -1 ), 48.0 ), 1, weapon );
	trigger_origin = weapon gettagorigin( "TAG_SAW" );
	trigger = spawn( "trigger_box", trigger_origin, 1, 16, 128, 64 );
	trigger.origin += anglestoup( weapon.angles ) * 32.0;
	trigger.angles = weapon.angles;
	trigger enablelinkto();
	trigger linkto( weapon );
	weapon.trigger = trigger;
	weapon thread headchopperthinkcleanup( trigger );
	direction_forward = anglestoforward( flat_angle( weapon.angles ) + vectorscale( ( -1, 0, 0 ), 60.0 ) );
	direction_vector = vectorscale( direction_forward, 1024 );
	direction_origin = weapon.origin + direction_vector;
	home_angles = weapon.angles;
	weapon.is_armed = 0;
	self thread headchopper_fx( weapon );
	self thread headchopper_animate( weapon, armed );

	while ( !( isdefined( weapon.is_armed ) && weapon.is_armed ) )
		wait 0.5;

	weapon.chop_targets = [];
	self thread targeting_thread( weapon, trigger );

	while ( isdefined( weapon ) )
	{
		wait_for_targets( weapon );

		if ( isdefined( weapon.chop_targets ) && weapon.chop_targets.size > 0 )
		{
			is_slicing = 1;
			slice_count = 0;

			weapon.headchopper_kills++;

			while ( isdefined( is_slicing ) && is_slicing )
			{
				weapon notify( "chop", 1 );
				weapon.is_armed = 0;
				weapon.zombies_only = 1;

				self headchopper_add_chop_ents( weapon, trigger );

				foreach ( ent in weapon.chop_targets )
					self thread headchopperattack( weapon, ent );

				weapon.chop_targets = [];
				weapon waittill_any( "slicing", "end" );

				slice_count++;
				is_slicing = weapon.is_slicing;
			}

			weapon notify( "slice_done" );

			while ( !( isdefined( weapon.is_armed ) && weapon.is_armed ) )
				wait 0.05;

			if ( weapon.headchopper_kills >= 10 )
			{
				self thread headchopper_expired( weapon );
				return;
			}
		}
		else
			wait 0.1;
	}
}

targeting_thread( weapon, trigger )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_headchopper_zm_taken" );
	weapon endon( "death" );
	weapon.zombies_only = 1;

	while ( isdefined( weapon ) )
	{
		if ( weapon.is_armed || isdefined( weapon.is_slicing ) && weapon.is_slicing )
		{
			if ( isdefined( weapon.is_slicing ) && weapon.is_slicing )
				weapon waittill( "slice_done" );

			self headchopper_add_chop_ents( weapon, trigger );

			if ( !weapon.zombies_only )
				weapon notify( "hi_priority_target" );
		}

		wait 0.05;
	}
}

headchopper_add_chop_ents( weapon, trigger )
{
	zombies = getaiarray( level.zombie_team );

	foreach ( zombie in zombies )
	{
		if ( !isdefined( zombie ) || !isalive( zombie ) )
			continue;

		if ( isdefined( zombie.ignore_headchopper ) && zombie.ignore_headchopper )
			continue;

		if ( zombie istouching( trigger ) )
			weapon headchopper_add_chop_ent( zombie );
	}

	players = get_players();

	foreach ( player in players )
	{
		if ( is_player_valid( player ) && player istouching( trigger ) )
		{
			weapon headchopper_add_chop_ent( player );
			weapon.zombies_only = 0;
		}
	}
}

wait_for_targets( weapon )
{
	weapon endon( "hi_priority_target" );

	while ( isdefined( weapon ) )
	{
		if ( isdefined( weapon.chop_targets ) && weapon.chop_targets.size > 0 )
		{
			return;
		}

		wait 0.05;
	}
}

headchopperattack( weapon, ent )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_headchopper_zm_taken" );
	weapon endon( "death" );

	if ( !isdefined( ent ) || !isalive( ent ) )
		return;

	eye_position = ent geteye();
	head_position = eye_position[2] + 13;
	foot_position = ent.origin[2];
	length_head_to_toe = abs( head_position - foot_position );
	length_head_to_toe_25_percent = length_head_to_toe * 0.25;
	is_headchop = weapon.origin[2] >= head_position - length_head_to_toe_25_percent;
	is_torsochop = weapon.origin[2] >= foot_position + length_head_to_toe_25_percent;
	is_footchop = abs( foot_position - weapon.origin[2] ) <= length_head_to_toe_25_percent;
	trace_point = undefined;

	if ( isdefined( is_headchop ) && is_headchop )
		trace_point = eye_position;
	else if ( isdefined( is_torsochop ) && is_torsochop )
		trace_point = ent.origin + ( 0, 0, length_head_to_toe_25_percent * 2 );
	else
		trace_point = ent.origin + ( 0, 0, length_head_to_toe_25_percent );

	fwdangles = anglestoup( weapon.angles );
	tracefwd = bullettrace( weapon.origin + fwdangles * 5, trace_point, 0, weapon, 1, 1 );

	if ( !isdefined( tracefwd ) || !isdefined( tracefwd["position"] ) || tracefwd["position"] != trace_point )
		return;

	if ( isplayer( ent ) )
	{
		if ( isdefined( is_headchop ) && is_headchop )
		{
			radiusdamage( ent.origin + (0, 0, 5), 10, 50, 50, weapon, "MOD_MELEE" );
		}
		else
		{
			radiusdamage( ent.origin + (0, 0, 5), 10, 25, 25, weapon, "MOD_MELEE" );
		}
	}
	else
	{
		if ( !( isdefined( is_headchop ) && is_headchop ) || !( isdefined( is_headchop ) && is_headchop ) && !( isdefined( ent.has_legs ) && ent.has_legs ) )
		{
			headchop_height = 25;

			if ( !( isdefined( ent.has_legs ) && ent.has_legs ) )
				headchop_height = 35;

			is_headchop = abs( eye_position[2] - weapon.origin[2] ) <= headchop_height;
		}

		if ( isdefined( is_headchop ) && is_headchop )
		{
			if ( !( isdefined( ent.no_gib ) && ent.no_gib ) )
				ent maps\mp\zombies\_zm_spawner::zombie_head_gib();

			ent dodamage( ent.health + 666, weapon.origin );
			ent.headchopper_last_damage_time = gettime();
			ent playsound( "zmb_exp_jib_headchopper_zombie" );
			self thread headchopper_kill_vo( ent );
		}
		else if ( isdefined( is_torsochop ) && is_torsochop )
		{
			if ( ent.health <= 20 )
			{
				ent playsound( "zmb_exp_jib_headchopper_zombie" );
				self thread headchopper_kill_vo( ent );
			}

			ent dodamage( 20, weapon.origin );
			ent.headchopper_last_damage_time = gettime();
		}
		else if ( isdefined( is_footchop ) && is_footchop )
		{
			if ( !( isdefined( ent.no_gib ) && ent.no_gib ) )
			{
				ent.a.gib_ref = "no_legs";
				ent thread maps\mp\animscripts\zm_death::do_gib();
				ent.has_legs = 0;
				ent allowedstances( "crouch" );
				ent setphysparams( 15, 0, 24 );
				ent allowpitchangle( 1 );
				ent setpitchorient();
				ent thread maps\mp\animscripts\zm_run::needsdelayedupdate();

				if ( isdefined( ent.crawl_anim_override ) )
					ent [[ ent.crawl_anim_override ]]();
			}

			if ( ent.health <= 10 )
			{
				ent playsound( "zmb_exp_jib_headchopper_zombie" );
				self thread headchopper_kill_vo( ent );
			}

			ent dodamage( 10, weapon.origin );
			ent.headchopper_last_damage_time = gettime();
		}
	}
}

setupwatchers()
{
	self waittill( "weapon_watchers_created" );

	watcher = maps\mp\gametypes_zm\_weaponobjects::getweaponobjectwatcher( "equip_headchopper" );
	watcher.onspawnretrievetriggers = ::equipment_onspawnretrievableweaponobject;
}

equipment_onspawnretrievableweaponobject( watcher, player )
{
	self.plant_parent = self;
	iswallmount = isdefined( level.placeable_equipment_type[self.name] ) && level.placeable_equipment_type[self.name] == "wallmount";

	if ( !isdefined( player.turret_placement ) || !player.turret_placement["result"] )
	{
		if ( iswallmount || !getdvarint( "tu11_zombie_turret_placement_ignores_bodies" ) )
		{
			self waittill( "stationary" );

			waittillframeend;

			if ( iswallmount )
			{
				if ( isdefined( player.planted_wallmount_on_a_zombie ) && player.planted_wallmount_on_a_zombie )
				{
					equip_name = self.name;
					equipment_disappear_fx( self.origin, undefined, self.angles );
					self delete();

					player.do_not_display_equipment_pickup_hint = 1;
					player maps\mp\zombies\_zm_equipment::equipment_take( equip_name );
					player maps\mp\zombies\_zm_equipment::equipment_give( equip_name );
					player.do_not_display_equipment_pickup_hint = undefined;

					player.planted_wallmount_on_a_zombie = undefined;
					return;
				}
			}
		}
		else
		{
			self.plant_parent = player;
			self.origin = player.origin;
			self.angles = player.angles;
			wait_network_frame();
		}
	}

	equipment = watcher.name + "_zm";

	if ( isdefined( player.current_equipment ) && player.current_equipment == equipment )
		player equipment_to_deployed( equipment );

	if ( isdefined( level.zombie_equipment[equipment].place_fn ) )
	{
		if ( isdefined( player.turret_placement ) && player.turret_placement["result"] )
		{
			plant_origin = player.turret_placement["origin"];
			plant_angles = player.turret_placement["angles"];
		}
		else if ( isdefined( level.placeable_equipment_type[self.name] ) && level.placeable_equipment_type[self.name] == "wallmount" )
		{
			plant_origin = self.origin;
			plant_angles = self.angles;
		}
		else
		{
			plant_origin = self.origin;
			plant_angles = self.angles;
		}

		if ( isdefined( level.check_force_deploy_origin ) )
		{
			if ( player [[ level.check_force_deploy_origin ]]( self, plant_origin, plant_angles ) )
			{
				plant_origin = player.origin;
				plant_angles = player.angles;
				self.plant_parent = player;
			}
		}
		else if ( isdefined( level.check_force_deploy_z ) )
		{
			if ( player [[ level.check_force_deploy_z ]]( self, plant_origin, plant_angles ) )
				plant_origin = ( plant_origin[0], plant_origin[1], player.origin[2] + 10 );
		}

		if ( isdefined( iswallmount ) && iswallmount )
			self ghost();

		replacement = player [[ level.zombie_equipment[equipment].place_fn ]]( plant_origin, plant_angles );

		if ( isdefined( replacement ) )
		{
			replacement.owner = player;
			replacement.original_owner = player;
			replacement.name = self.name;
			player notify( "equipment_placed", replacement, self.name );

			if ( isdefined( level.equipment_planted ) )
				player [[ level.equipment_planted ]]( replacement, equipment, self.plant_parent );

			player maps\mp\zombies\_zm_buildables::track_buildables_planted( self );
		}

		if ( isdefined( self ) )
			self delete();
	}
}