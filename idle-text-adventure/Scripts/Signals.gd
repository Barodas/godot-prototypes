extends Node

# TODO: Should data be moved into seperate structures? (Character contains CharacterData?)

signal change_screen(name)
signal character_changed(character: Character)
signal log_changed(log_entry: LogEntry)

signal change_character_action(character_id: String, action: String)
signal equip_item(character_id: String, slot: int)
signal unequip_item(character_id: String, equip_slot: String)

signal delete_item(owner_id: String, slot: int)
signal transfer_item(owner_id: String, target_id: String, slot: int)

signal storage_changed(storage)
