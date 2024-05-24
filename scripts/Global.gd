extends Node

var current_level = 0
var current_hp = 200
var max_hp = 200
var current_money = 0
var bullet_dmg = 20

const tile_size = 16
const room_size = 30 * tile_size
const coridor_size = 20 * tile_size
const hole_size = 4 * tile_size
const sum_size = room_size + coridor_size
