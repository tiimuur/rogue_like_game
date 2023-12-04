extends Control


func _ready():
	pass


func _process(delta):
	pass


func makeButton(index, pos):
	var item = get_parent().chestItems[index]
	var newButton = Button.new()
	newButton.icon = item.texture
	newButton.position.x = pos.x
	newButton.position.y = pos.y
	newButton.connect("pressed", self, "makeButton", [1])
