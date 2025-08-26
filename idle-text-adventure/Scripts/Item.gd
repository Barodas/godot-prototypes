class_name Item #extends Reference

var item_id: String
var name: String
var amount: int

var is_equipable: bool

static func create(item_id: String, name: String, amount: int):
	var item = Item.new()
	item.item_id = item_id
	item.name = name
	item.amount = amount
	item.is_equipable = false
	return item
