extends PanelContainer

var owner_id: String
var slot: int
var store_id: String

static func create(item: Item, is_storable: bool):
	var scene = load("res://InventoryItem.tscn")
	var instance = scene.instance()
	instance.name_label.text = item.name
	instance.amount_label.text = item.amount
	instance.equip_button.visible = false
	instance.store_button.visible = is_storable
	instance.destroy_button.visible = true
	return instance

func init(owner: String, slot_number: int, item: Item, store_target: String = "none"):
	owner_id = owner
	slot = slot_number
	store_id = store_target
	$HBoxContainer/Name.text = item.name
	$HBoxContainer/Amount.text = "%s" % [item.amount]
	var equip_button = $HBoxContainer/EquipButton
	equip_button.visible = item.is_equipable && owner != "storage"
	equip_button.pressed.connect(_on_equip_pressed)
	var transfer_button = $HBoxContainer/TransferButton
	transfer_button.visible = store_target != "none"
	transfer_button.pressed.connect(_on_storage_pressed)
	#if owner == "guild":
	#	transfer_button.text = "Transfer"
	var destroy_button = $HBoxContainer/DestroyButton
	destroy_button.visible = true
	destroy_button.pressed.connect(_on_delete_pressed)

func _on_equip_pressed():
	Signals.equip_item.emit(owner_id, slot)

func _on_storage_pressed():
	Signals.transfer_item.emit(owner_id, store_id, slot)

func _on_delete_pressed():
	Signals.delete_item.emit(owner_id, slot)
