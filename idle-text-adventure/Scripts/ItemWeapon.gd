class_name ItemWeapon extends Item

var equip_slot: String
var damage: int

static func create_weapon(item_id: String, name: String, equip_slot: String, damage: int):
	var item = ItemWeapon.new()
	item.item_id = item_id
	item.name = name
	item.amount = 1
	item.is_equipable = true
	item.equip_slot = equip_slot
	item.damage = damage
	return item
