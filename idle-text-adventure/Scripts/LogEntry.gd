class_name LogEntry

var tags = []
var message: String

static func create(message: String, tags):
	var entry = LogEntry.new()
	entry.message = message
	entry.tags = tags
	return entry

func has_tag(tag: String):
	for i in tags:
		if tag == i:
			return true
	return false
