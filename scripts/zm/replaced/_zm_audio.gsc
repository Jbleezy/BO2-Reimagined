#include maps\mp\zombies\_zm_audio;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\_music;
#include maps\mp\zombies\_zm_spawner;

create_and_play_dialog( category, type, response, force_variant, override )
{
    waittime = 0.25;

    if ( !isdefined( self.zmbvoxid ) )
    {
        return;
    }

    if ( isdefined( self.dontspeak ) && self.dontspeak )
	{
		return;
	}

	if ( getDvarInt("disable_character_dialog") )
	{
		return;
	}

    isresponse = 0;
    alias_suffix = undefined;
    index = undefined;
    prefix = undefined;

    if ( !isdefined( level.vox.speaker[self.zmbvoxid].alias[category][type] ) )
        return;

    prefix = level.vox.speaker[self.zmbvoxid].prefix;
    alias_suffix = level.vox.speaker[self.zmbvoxid].alias[category][type];

    if ( self is_player() )
    {
        if ( self.sessionstate != "playing" )
            return;

        if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && ( type != "revive_down" || type != "revive_up" ) )
            return;

        index = maps\mp\zombies\_zm_weapons::get_player_index( self );
        prefix = prefix + index + "_";
    }

    if ( isdefined( response ) )
    {
        if ( isdefined( level.vox.speaker[self.zmbvoxid].response[category][type] ) )
            alias_suffix = response + level.vox.speaker[self.zmbvoxid].response[category][type];

        isresponse = 1;
    }

    sound_to_play = self zmbvoxgetlinevariant( prefix, alias_suffix, force_variant, override );

    if ( isdefined( sound_to_play ) )
    {
        if ( isdefined( level._audio_custom_player_playvox ) )
            self thread [[ level._audio_custom_player_playvox ]]( prefix, index, sound_to_play, waittime, category, type, override );
        else
            self thread do_player_or_npc_playvox( prefix, index, sound_to_play, waittime, category, type, override, isresponse );
    }
}