#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_banking;

init()
{
	onplayerconnect_callback( ::onplayerconnect_bank_deposit_box );
	if ( !isDefined( level.ta_vaultfee ) )
	{
		level.ta_vaultfee = 100;
	}
	if ( !isDefined( level.ta_tellerfee ) )
	{
		level.ta_tellerfee = 100;
	}
}

onplayerconnect_bank_deposit_box()
{
	self.account_value = 0;
	self thread gain_interest_after_rounds();
}

gain_interest_after_rounds()
{
	self endon("disconnect");

	while(1)
	{
		level waittill("end_of_round");

		self.account_value *= 1.1;
		if(self.account_value > level.bank_account_max)
		{
			self.account_value = level.bank_account_max;
		}
	}
}

bank_deposit_box()
{
	level.bank_deposit_max_amount = 250000;
	level.bank_deposit_ddl_increment_amount = 1000;
	level.bank_account_max = level.bank_deposit_max_amount / level.bank_deposit_ddl_increment_amount;
	level.bank_account_increment = int( level.bank_deposit_ddl_increment_amount / 1000 );
	deposit_triggers = getstructarray( "bank_deposit", "targetname" );
	array_thread( deposit_triggers, ::bank_deposit_unitrigger );
	withdraw_triggers = getstructarray( "bank_withdraw", "targetname" );
	array_thread( withdraw_triggers, ::bank_withdraw_unitrigger );
}

bank_deposit_unitrigger()
{
	bank_unitrigger( "bank_deposit", ::trigger_deposit_update_prompt, ::trigger_deposit_think, 5, 5, undefined, 5 );
}

bank_withdraw_unitrigger()
{
	bank_unitrigger( "bank_withdraw", ::trigger_withdraw_update_prompt, ::trigger_withdraw_think, 5, 5, undefined, 5 );
}

trigger_deposit_think()
{
	self endon( "kill_trigger" );
	while ( 1 )
	{
		self waittill( "trigger", player );
		while ( !is_player_valid( player ) )
		{
			continue;
		}
		if ( player.account_value < level.bank_account_max )
		{
			account_value = level.bank_account_increment;
			score = level.bank_deposit_ddl_increment_amount;

			if(score > player.score)
			{
				account_value = player.score / level.bank_deposit_ddl_increment_amount;
				score = player.score;
			}

			if((player.account_value + account_value) > level.bank_account_max)
			{
				account_value = level.bank_account_max - player.account_value;
				score = round_up_to_ten(int(account_value * level.bank_deposit_ddl_increment_amount));
				score -= score % 10;
			}

			player playsoundtoplayer( "zmb_vault_bank_deposit", player );
			player.score -= score;
			player.account_value += account_value;
			if ( isDefined( level.custom_bank_deposit_vo ) )
			{
				player thread [[ level.custom_bank_deposit_vo ]]();
			}
			if ( (player.score <= 0) || (player.account_value >= level.bank_account_max) )
			{
				self sethintstring( "" );
			}
		}
		else
		{
			player thread do_player_general_vox( "general", "exert_sigh", 10, 50 );
		}
		player show_balance();
	}
}

trigger_withdraw_think()
{
	self endon( "kill_trigger" );
	while ( 1 )
	{
		self waittill( "trigger", player );
		while ( !is_player_valid( player ) )
		{
			continue;
		}
		if ( player.account_value > 0 )
		{
			score = level.bank_deposit_ddl_increment_amount;
			account_value = level.bank_account_increment;

			if(account_value > player.account_value)
			{
				account_value = player.account_value;
				score = round_up_to_ten(int(account_value * level.bank_deposit_ddl_increment_amount));
			}

			player playsoundtoplayer( "zmb_vault_bank_withdraw", player );
			player.score += score;
			level notify( "bank_withdrawal" );
			player.account_value -= account_value;
			if ( isDefined( level.custom_bank_withdrawl_vo ) )
			{
				player thread [[ level.custom_bank_withdrawl_vo ]]();
			}
			else
			{
				player thread do_player_general_vox( "general", "exert_laugh", 10, 50 );
			}
			if ( player.account_value <= 0 )
			{
				self sethintstring( "" );
			}
		}
		else
		{
			player thread do_player_general_vox( "general", "exert_sigh", 10, 50 );
		}
		player show_balance();
	}
}

trigger_deposit_update_prompt( player )
{
	player show_balance();
	if ( (player.score <= 0) || (player.account_value >= level.bank_account_max) )
	{
		self sethintstring( "" );
		return 0;
	}
	self sethintstring( &"ZOMBIE_BANK_DEPOSIT_PROMPT", level.bank_deposit_ddl_increment_amount );
	return 1;
}

trigger_withdraw_update_prompt( player )
{
	player show_balance();
	if ( player.account_value <= 0 )
	{
		self sethintstring( "" );
		return 0;
	}
	self sethintstring( &"ZOMBIE_BANK_WITHDRAW_PROMPT", level.bank_deposit_ddl_increment_amount, level.ta_vaultfee );
	return 1;
}

show_balance()
{
	self iprintlnbold("Account Balance: " + round_up_to_ten(int(self.account_value * level.bank_deposit_ddl_increment_amount)));
}