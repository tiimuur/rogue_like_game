extends StaticBody2D


class Item:
	func _init(newName, newTexture, position, fun):
		name = newName
		texture = newTexture
		button = Button.new()
		button.icon = texture
		button.text = "PICK ME"
		button.position.x = position.x
		button.position.y = position.y + 40
		button.connect("pressed", fun.bind(button))
	
	
	var name
	var texture
	var button


var is_opened = false
var chestItems = []


func deleteItemByButton(button):
	var newChestItems = []
	for item in chestItems:
		if item.button != button:
			newChestItems.append(item)
	chestItems = newChestItems


func _ready():
	chestItems.append(Item.new("Some Gun", preload("res://Sprites/pistolet.png"), 
	position, pickItem))


func isNear(object1, object2):
	return abs(object1.x - object2.x) < 64 and abs(object1.y - object2.y) < 64


func closeChest():
	is_opened = false
	for item in chestItems:
		get_parent().remove_child(item.button)
	


func openChest():
	is_opened = true
	for item in chestItems:
		get_parent().add_child(item.button)



func pickItem(button):
	get_parent().remove_child(button)
	deleteItemByButton(button)



func _process(delta):
	var player = get_parent().get_player()
	if is_opened and not isNear(player.position, position):
		closeChest()
	if Input.is_action_just_pressed("Open") and isNear(player.position, position):
		if not is_opened:
			openChest()
		else:
			closeChest()
