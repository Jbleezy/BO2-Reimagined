#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_buildables_pooled;

add_buildable_to_pool( stub, poolname )
{
	if ( !isDefined( level.buildablepools ) )
	{
		level.buildablepools = [];
	}
	if ( !isDefined( level.buildablepools[ poolname ] ) )
	{
		level.buildablepools[ poolname ] = spawnstruct();
		level.buildablepools[ poolname ].stubs = [];
	}
	level.buildablepools[ poolname ].stubs[ level.buildablepools[ poolname ].stubs.size ] = stub;
	if ( !isDefined( level.buildablepools[ poolname ].buildable_slot ) )
	{
		level.buildablepools[ poolname ].buildable_slot = stub.buildablestruct.buildable_slot;
	}
	stub.buildable_pool = level.buildablepools[ poolname ];
	stub.original_prompt_and_visibility_func = stub.prompt_and_visibility_func;
	stub.original_trigger_func = stub.trigger_func;
	stub.prompt_and_visibility_func = ::pooledbuildabletrigger_update_prompt;
	reregister_unitrigger( stub, ::pooled_buildable_place_think );
}

pooledbuildabletrigger_update_prompt( player )
{
	can_use = self.stub pooledbuildablestub_update_prompt( player, self );
	self sethintstring( self.stub.hint_string );
	if ( isDefined( self.stub.cursor_hint ) )
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && isDefined( self.stub.cursor_hint_weapon ) )
		{
			self setcursorhint( self.stub.cursor_hint, self.stub.cursor_hint_weapon );
		}
		else
		{
			self setcursorhint( self.stub.cursor_hint );
		}
	}
	if(can_use)
	{
		self thread pooledbuildabletrigger_wait_and_update_prompt( player );
	}
	return can_use;
}

pooledbuildabletrigger_wait_and_update_prompt( player )
{
	self notify("pooledbuildabletrigger_wait_and_update_prompt");
	self endon("pooledbuildabletrigger_wait_and_update_prompt");

	self waittill("trigger");

	self pooledbuildabletrigger_update_prompt( player );
}