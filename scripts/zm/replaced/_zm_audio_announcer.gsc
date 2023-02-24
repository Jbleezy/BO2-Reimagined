#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_audio_announcer;

playleaderdialogonplayer( dialog, team, waittime )
{
	self endon( "disconnect" );

	if ( level.allowzmbannouncer )
	{
		if ( !isDefined( game[ "zmbdialog" ][ dialog ] ) )
		{
			return;
		}
	}

	if ( isDefined( self.zmbdialoggroups[ dialog ] ) )
	{
		group = dialog;
		dialog = self.zmbdialoggroups[ group ];
		self.zmbdialoggroups[ group ] = undefined;
	}

	if ( level.allowzmbannouncer )
	{
		alias = game[ "zmbdialog" ][ "prefix" ] + "_" + game[ "zmbdialog" ][ dialog ];
		variant = self getleaderdialogvariant( alias );

		if ( !isDefined( variant ) )
		{
			full_alias = alias;
		}
		else
		{
			full_alias =  alias + "_" + variant;
		}

		self playlocalsound( full_alias );
	}
}