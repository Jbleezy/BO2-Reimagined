zm_stop_idle : notify stop_idle
{
	zombie_dog_idle
}

zm_stop_attackidle_growl : notify attack_idle restart
{
	zombie_dog_attackidle_growl
}

zm_stop_attackidle : notify attack_idle restart
{
	zombie_dog_attackidle
}

zm_stop_attackidle_bark : notify attack_idle restart
{
	zombie_dog_attackidle_bark
}

zm_combat_attack_player_close_range : notify attack_combat restart
{
	zombie_dog_run_attack_low
}

zm_combat_attackidle_growl : notify attack_combat restart
{
	zombie_dog_run_attack
}

zm_combat_attackidle : notify attack_combat restart
{
	zombie_dog_run_attack
}

zm_combat_attackidle_bark : notify attack_combat restart
{
	zombie_dog_run_attack
}

zm_move_run : notify move_run
{
	zombie_dog_run
}

zm_move_stop : notify move_stop
{
	zombie_dog_run_stop
}

zm_move_walk : notify move_walk
{
	zombie_dog_trot
}

zm_move_start : notify move_start
{
	zombie_dog_run_start
}

zm_traverse_wallhop : notify traverse_wallhop
{
	zombie_dog_traverse_up_40
}

move_turn_left : notify move_turn
{
	zombie_dog_turn_90_left
}

move_run_turn_left : notify move_turn
{
	zombie_dog_run_turn_90_left
}

move_turn_right : notify move_turn
{
	zombie_dog_turn_90_right
}

move_run_turn_right : notify move_turn
{
	zombie_dog_run_turn_90_right
}

move_turn_around_left : notify move_turn
{
	zombie_dog_turn_180_left
}

move_run_turn_around_left : notify move_turn
{
	zombie_dog_run_turn_180_left
}

move_run_turn_around_right : notify move_turn
{
	zombie_dog_run_turn_180_right
}


move_turn_around_right : notify move_turn
{
	zombie_dog_turn_180_right
}

move_run_turn_around_right2 : notify move_turn
{
	zombie_dog_run_turn_180_right
}

death_front : notify dead_dog
{
	zombie_dog_death_front
}

death_right : notify dead_dog
{
	zombie_dog_death_hit_right
}

death_back : notify dead_dog
{
	zombie_dog_death_hit_back
}

death_left : notify dead_dog
{
	zombie_dog_death_hit_left
}

zm_traverse_barrier : aliased restart notify traverse_anim
{
	barrier_walk	zombie_dog_run_jump_window_40
	barrier_walk	zombie_dog_run_jump_window_40
	barrier_run		zombie_dog_run_jump_window_40
	barrier_sprint	zombie_dog_run_jump_window_40
	barrier_sprint	zombie_dog_run_jump_window_40
}

zm_barricade_enter : aliased restart notify barricade_enter_anim
{
	barrier_walk_m		zombie_dog_run_jump_window_40
	barrier_run_m		zombie_dog_run_jump_window_40
	barrier_sprint_m	zombie_dog_run_jump_window_40

	barrier_walk_r		zombie_dog_run_jump_window_40
	barrier_run_r		zombie_dog_run_jump_window_40
	barrier_sprint_r	zombie_dog_run_jump_window_40

	barrier_walk_l		zombie_dog_run_jump_window_40
	barrier_run_l		zombie_dog_run_jump_window_40
	barrier_sprint_l	zombie_dog_run_jump_window_40
}

////traverse anims, not all necessarily used on every level
zm_traverse : aliased restart notify traverse_anim
{
//	jump_down_48			zombie_dog_traverse_down_40
//	jump_down_96			zombie_dog_traverse_down_96
	jump_down_127			zombie_dog_traverse_down_126
//	jump_down_190			zombie_dog_traverse_down_190
//	jump_down_222			zombie_dog_traverse_down_190
	jump_up_127				zombie_dog_traverse_up_40
//	jump_up_222				zombie_dog_traverse_up_80
//	jump_across_120			ai_zombie_dog_jump_across_120
}
