extends Node

var current_level = 0
var current_hp = 200
var max_hp = 200
var current_money = 0
var bullet_dmg = 20
var ammo_size = 5
var time_between_reload_anim = 0.1
var max_stamina = 100

const tile_size = 16
const room_size = 30 * tile_size
const coridor_size = 20 * tile_size
const hole_size = 4 * tile_size
const sum_size = room_size + coridor_size
