#include maps\mp\zombies\_zm_riotshield;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_weap_riotshield;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_weapons;

doriotshielddeploy( origin, angles )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );
	self notify( "deployed_riotshield" );
	self maps\mp\zombies\_zm_buildables::track_placed_buildables( level.riotshield_name );

	if ( isdefined( self.current_equipment ) && self.current_equipment == level.riotshield_name )
		self maps\mp\zombies\_zm_equipment::equipment_to_deployed( level.riotshield_name );

	zoffset = level.riotshield_placement_zoffset;
	shield_ent = self spawnriotshieldcover( origin + ( 0, 0, zoffset ), angles );
	item_ent = deployriotshield( self, shield_ent );
	primaries = self getweaponslistprimaries();

	self maps\mp\zombies\_zm_weapons::switch_back_primary_weapon(self.riotshield_prev_wep);

	if ( isdefined( level.equipment_planted ) )
		self [[ level.equipment_planted ]]( shield_ent, level.riotshield_name, self );

	if ( isdefined( level.equipment_safe_to_drop ) )
	{
		if ( !self [[ level.equipment_safe_to_drop ]]( shield_ent ) )
		{
			self notify( "destroy_riotshield" );
			shield_ent delete();
			item_ent delete();
			return;
		}
	}

	self.riotshieldretrievetrigger = item_ent;
	self.riotshieldentity = shield_ent;
	self thread watchdeployedriotshieldents();
	self thread deleteshieldondamage( self.riotshieldentity );
	self thread deleteshieldmodelonweaponpickup( self.riotshieldretrievetrigger );
	self thread deleteriotshieldonplayerdeath();
	self thread watchshieldtriggervisibility( self.riotshieldretrievetrigger );
	self.riotshieldentity thread watchdeployedriotshielddamage();
	return shield_ent;
}

trackriotshield()
{
	self endon( "death" );
	self endon( "disconnect" );
	self.hasriotshield = self hasweapon( level.riotshield_name );
	self.hasriotshieldequipped = self getcurrentweapon() == level.riotshield_name;
	self.shield_placement = 0;

	if ( self.hasriotshield )
	{
		if ( self.hasriotshieldequipped )
		{
			self.shield_placement = 1;
			self updateriotshieldmodel();
		}
		else
		{
			self.shield_placement = 2;
			self updateriotshieldmodel();
		}
	}

	for (;;)
	{
		self waittill( "weapon_change", newweapon );

		foreach (wep in self getWeaponsListPrimaries())
		{
			if (wep == newweapon)
			{
				self.riotshield_prev_wep = newweapon;
				break;
			}
		}

		if ( newweapon == level.riotshield_name )
		{
			if ( self.hasriotshieldequipped )
				continue;

			if ( isdefined( self.riotshieldentity ) )
				self notify( "destroy_riotshield" );

			self.shield_placement = 1;
			self updateriotshieldmodel();

			self.hasriotshield = 1;
			self.hasriotshieldequipped = 1;
			continue;
		}

		if ( self ismantling() && newweapon == "none" )
			continue;

		if ( self.hasriotshieldequipped )
		{
			assert( self.hasriotshield );
			self.hasriotshield = self hasweapon( level.riotshield_name );

			if ( isdefined( self.riotshield_hidden ) && self.riotshield_hidden )
			{

			}
			else if ( self.hasriotshield )
				self.shield_placement = 2;
			else if ( isdefined( self.shield_ent ) )
				assert( self.shield_placement == 3 );
			else
				self.shield_placement = 0;

			self updateriotshieldmodel();
			self.hasriotshieldequipped = 0;
			continue;
		}

		if ( self.hasriotshield )
		{
			if ( !self hasweapon( level.riotshield_name ) )
			{
				self.shield_placement = 0;
				self updateriotshieldmodel();
				self.hasriotshield = 0;
			}

			continue;
		}

		if ( self hasweapon( level.riotshield_name ) )
		{
			self.shield_placement = 2;
			self updateriotshieldmodel();
			self.hasriotshield = 1;
		}
	}
}