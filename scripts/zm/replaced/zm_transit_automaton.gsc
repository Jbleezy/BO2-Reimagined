#include maps\mp\zm_transit_automaton;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_transit_utility;
#include maps\mp\zm_transit_bus;

#using_animtree("zm_transit_automaton");

automatonsetup()
{
	self linkto(level.the_bus);
	self useanimtree(#animtree );
	self setanim(%ai_zombie_bus_driver_idle);
	self addasspeakernpc(1);
	level.vox zmbvoxinitspeaker("automaton", "vox_bus_", self);
	self thread automatondamagecallback();
	self thread automatonanimationsspeaking();
	self thread automatonemp();
	level thread bus_upgrade_vox();
}