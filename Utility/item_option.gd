extends ColorRect

@onready var lblName = $lbl_name
@onready var lblDescription = $lbl_description
@onready var lblLevel = $lbl_level
@onready var itemIcon = $ColorRect/ItemIcon

var mouse_over = false
var item = null

@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	if item == null:
		item = "food"
	lblName.text = UpgradesDb.UPGRADES[item]["displayname"]
	lblDescription.text = UpgradesDb.UPGRADES[item]["details"]
	lblLevel.text = UpgradesDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradesDb.UPGRADES[item]["icon"])
	

func _input(event) -> void:
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)


func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
