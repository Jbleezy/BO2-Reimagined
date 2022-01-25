#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_weap_claymore;

claymore_detonation()
{
	self endon( "death" );
	self waittill_not_moving();
	detonateradius = 96;
	damagearea = spawn( "trigger_radius", self.origin + ( 0, 0, 0 - detonateradius ), 4, detonateradius, detonateradius * 2 );
	damagearea setexcludeteamfortrigger( self.team );
	damagearea enablelinkto();
	damagearea linkto( self );
	if ( is_true( self.isonbus ) )
	{
		damagearea setmovingplatformenabled( 1 );
	}
	self.damagearea = damagearea;
	self thread delete_claymores_on_death( self.owner, damagearea );
	self.owner.claymores[ self.owner.claymores.size ] = self;
	while ( 1 )
	{
		damagearea waittill( "trigger", ent );
		if ( isDefined( self.owner ) && ent == self.owner )
		{
			continue;
		}
		if ( isDefined( ent.pers ) && isDefined( ent.pers[ "team" ] ) && ent.pers[ "team" ] == self.team )
		{
			continue;
		}
        if ( isDefined( ent.pers ) && isDefined( ent.pers[ "team" ] ) && ent.pers[ "team" ] == getOtherTeam( self.team ) )
		{
			continue;
		}
		if ( isDefined( ent.ignore_claymore ) && ent.ignore_claymore )
		{
			continue;
		}
		if ( !ent shouldaffectweaponobject( self ) )
		{
			continue;
		}
		if ( ent damageconetrace( self.origin, self ) > 0 )
		{
			self playsound( "wpn_claymore_alert" );
			wait 0.4;
			if ( isDefined( self.owner ) )
			{
				self detonate( self.owner );
			}
			else
			{
				self detonate( undefined );
			}
			return;
		}
	}
}