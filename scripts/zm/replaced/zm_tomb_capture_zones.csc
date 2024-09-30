#include clientscripts\mp\zm_tomb_capture_zones;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_music;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_fx;

register_perk_machine_smoke_struct_references()
{
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_1", "revive_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_2", "deadshot_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_3", "speedcola_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_4", "jugg_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_5", "staminup_pipes");
	register_perk_machine_smoke_struct_with_field_name("zone_capture_perk_machine_smoke_fx_6", "doubletap_pipes");
}