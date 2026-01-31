#include clientscripts\mp\zombies\_zm_turned;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_face_utility_zm;

init()
{
	precache();
}

zombie_turned_set_ir(lcn, newval)
{
	if (newval)
	{
		setlutscriptindex(lcn, 2);
		enable_filter_zm_turned(self, 0, 0);
		self setsonarattachmentenabled(1);
		self thread zombie_turned_ir_cleanup_on_intermission(lcn);
	}
	else
	{
		setlutscriptindex(lcn, 0);
		disable_filter_zm_turned(self, 0, 0);
		self setsonarattachmentenabled(0);
		self notify("zombie_turned_ir_cleanup_on_intermission");
	}
}

zombie_turned_ir_cleanup_on_intermission(lcn)
{
	self notify("zombie_turned_ir_cleanup_on_intermission");
	self endon("zombie_turned_ir_cleanup_on_intermission");
	self endon("disconnect");

	level waittill("zi");

	self zombie_turned_set_ir(lcn, 0);
}