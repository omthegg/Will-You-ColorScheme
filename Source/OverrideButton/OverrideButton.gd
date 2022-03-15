extends Button

var override_name:String
var override_text:String

var t


func save_file(dir:String, content:String):
	var file = File.new()
	file.open(dir, File.WRITE)
	file.store_string(content)
	file.close()


func load_file(dir:String):
	var file = File.new()
	file.open(dir, File.READ)
	var content = file.get_as_text()
	file.close()
	return content


func save():
	save_file(str(Globals.directory, "/Overrides/", override_name, ".txt"), override_text)


func delete():
	var dir = Directory.new()
	dir.remove(str(Globals.directory, "/Overrides/", override_name, ".txt"))
	queue_free()


func _on_OverrideButton_pressed():
	t = load_file(str(Globals.directory, "/Overrides/", override_name, ".txt"))
	if !override_text:
		override_text = t
	
	Globals.editor_textedit.text = override_text
	Globals.editor.selected_file = override_name
	Globals.editor_filename.text = override_name
	
	Globals.editor.get_node("Bar/DeleteOverride").disabled = false
