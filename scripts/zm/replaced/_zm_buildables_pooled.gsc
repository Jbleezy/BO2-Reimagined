#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_buildables_pooled;

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

	if (can_use && is_true(self.stub.built))
	{
		self sethintstring( self.stub.hint_string, " [Cost: " + self.stub.cost + "]" );
	}
	else
	{
		self sethintstring( self.stub.hint_string );
	}

	self setcursorhint( "HINT_NOICON" );

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