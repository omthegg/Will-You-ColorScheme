extends Node2D

var directory:String

var normal_text:String
var disco_text:String
var underwater_text:String
var bubblegum_text:String
var winter_text:String
var brain_text:String

var overrides:Array = []

var base_file_names:Array = [
	"Normal",
	"Disco",
	"Underwater",
	"Bubblegum",
	"Winter",
	"Brain"
]

var selected_file:String


# This is unused
var color_values = [
	"Background",
	"Background Pattern",
	"Background In Darkness",
	"Background Pattern In Darkness",
	"Wall A",
	"Wall B",
	"Wall A Dark",
	"Wall B Dark",
	"Wall Outline A",
	"Wall Outline B",
	"AI A",
	"AI B",
	"Snail Theme",
	"Snail Glow",
	"Player Spotlight",
	"Player Spotlight Dark",
	"Snail Death",
	"Snail Trail",
	"Enemies",
	"Enemy Warnings",
	"Snail Outline",
	"Snail Body",
	"Snail Shell",
	"Snail Eye",
	"Dallin",
	"Dialog Files",
	"Overlay Gradient Color Top",
	"Overlay Gradient Color Bot",
	"Overlay Vignette Color",
	"Bloom Color",
	"Lvl Locked Front",
	"Lvl Locked Back",
	"Lvl Normal Front",
	"Lvl Normal Back",
	"Lvl Story Front",
	"Lvl Story Back",
	"Lvl Secret Front",
	"Lvl Secret Back",
	"Lvl Questionmark Indicator",
	"Lvl Questionmark Indicator Selected",
	"Bubbles",
	"Underw Currents",
	"Snail Flare",
	"AI In Background",
	"Light Ocean",
	"Conveyor Belts",
	"Final Boss 1A",
	"Final Boss 1B",
	"Final Boss 2",
	"Final Boss 3",
	"TD Turret 1",
	"TD Turret 2",
	"TD Turret 3",
	"Exploration Points",
	"Corrupted Antenna",
	"Dialog File Overlay",
	"Doors",
	"Unicorn",
	"Smiley 1",
	"Smiley 2",
]


func _ready():
	#$TextEdit.add_keyword_color(":", Color8(116, 157, 32))
	#$TextEdit.add_color_region("\n", ":", Color8(247, 112, 21))
	Globals.editor = self
	Globals.editor_textedit = $TextEdit
	Globals.editor_filename = $FileName
	
	load_all(Globals.directory)
	
	$TextEdit.add_keyword_color("RGB", Color8(219, 57, 35))
	$TextEdit.add_keyword_color("HSV", Color8(126, 168, 160))
	
	$TextEdit.grab_focus()
	
	#for k in color_values:
		#var s = str(k[0], k[1], k[2])
		#var e = str(k[len(k) - 1])
		#
		#if k == "Unicorn":
		#	print(s)
		#	print(e)
		
		#$TextEdit.add_color_region(s, e, Color8(106, 184, 156), true)
		#$TextEdit.add_keyword_color(k, Color8(106, 184, 156))


func _input(_event):
	if Input.is_action_just_pressed("new_override"):
		$NewOverride.show()
	if Input.is_action_just_pressed("save"):
		save_all(directory)


func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				overrides.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



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


func load_all(dir:String):
	directory = dir
	load_normal(dir)
	load_disco(dir)
	load_underwater(dir)
	load_bubblegum(dir)
	load_winter(dir)
	load_brain(dir)
	
	dir_contents(str(dir, "/Overrides"))
	
	for i in overrides:
		var ob_instance = Globals.override_button.instance()
		$Control/ScrollContainer/VBoxContainer.call_deferred("add_child", ob_instance)
		var n = i.replace(".txt", "")
		
		ob_instance.set_name(n)
		ob_instance.text = n
		ob_instance.override_name = ob_instance.text


func load_normal(dir:String):
	normal_text = load_file(str(dir, "/Normal.txt"))


func load_disco(dir:String):
	disco_text = load_file(str(dir, "/Disco.txt"))


func load_underwater(dir:String):
	underwater_text = load_file(str(dir, "/Underwater.txt"))


func load_bubblegum(dir:String):
	bubblegum_text = load_file(str(dir, "/Bubblegum.txt"))


func load_winter(dir:String):
	winter_text = load_file(str(dir, "/Winter.txt"))


func load_brain(dir:String):
	brain_text = load_file(str(dir, "/Brain.txt"))


func save_all(dir:String):
	save_normal(dir)
	save_disco(dir)
	save_underwater(dir)
	save_bubblegum(dir)
	save_winter(dir)
	save_brain(dir)
	
	for i in overrides:
		var a = i.replace(".txt", "")
		var b
		for j in $Control/ScrollContainer/VBoxContainer.get_children():
			if !(j.get("override_name") == null):
				if j.override_name == a:
					b = j
		
		b.save()
	
	print("Saved")


func save_normal(dir:String):
	save_file(str(dir, "/Normal.txt"), normal_text)


func save_disco(dir:String):
	save_file(str(dir, "/Disco.txt"), disco_text)


func save_underwater(dir:String):
	save_file(str(dir, "/Underwater.txt"), underwater_text)


func save_bubblegum(dir:String):
	save_file(str(dir, "/Bubblegum.txt"), bubblegum_text)


func save_winter(dir:String):
	save_file(str(dir, "/Winter.txt"), winter_text)


func save_brain(dir:String):
	save_file(str(dir, "/Brain.txt"), brain_text)



func _on_NormalButton_pressed():
	$TextEdit.text = normal_text
	selected_file = "Normal"
	$FileName.text = selected_file
	$Bar/DeleteOverride.disabled = true


func _on_DiscoButton_pressed():
	$TextEdit.text = disco_text
	selected_file = "Disco"
	$FileName.text = selected_file
	$Bar/DeleteOverride.disabled = true


func _on_UnderwaterButton_pressed():
	$TextEdit.text = underwater_text
	selected_file = "Underwater"
	$FileName.text = selected_file
	$Bar/DeleteOverride.disabled = true


func _on_BubblegumButton_pressed():
	$TextEdit.text = bubblegum_text
	selected_file = "Bubblegum"
	$FileName.text = selected_file
	$Bar/DeleteOverride.disabled = true


func _on_WinterButton_pressed():
	$TextEdit.text = winter_text
	selected_file = "Winter"
	$FileName.text = selected_file
	$Bar/DeleteOverride.disabled = true


func _on_BrainButton_pressed():
	$TextEdit.text = brain_text
	selected_file = "Brain"
	$FileName.text = selected_file
	$Bar/DeleteOverride.disabled = true


func _on_TextEdit_text_changed():
	match selected_file:
		"Normal":
			normal_text = $TextEdit.text
		"Disco":
			disco_text = $TextEdit.text
		"Underwater":
			underwater_text = $TextEdit.text
		"Bubblegum":
			bubblegum_text = $TextEdit.text
		"Winter":
			winter_text = $TextEdit.text
		"Brain":
			brain_text = $TextEdit.text
	
	if !(selected_file in base_file_names):
		var f = $Control/ScrollContainer/VBoxContainer.get_node(selected_file)
		f.override_text = $TextEdit.text
		print(f.override_text)
	


func _on_UnderwaterCheckBox_toggled(button_pressed):
	$NewOverride/InvLabel.visible = button_pressed



func _on_CreateButton_pressed():
	var n = $NewOverride/OverrideName.text
	
	$NewOverride.hide()
	$NewOverride/OverrideName.text = ""
	
	var underwater = $NewOverride/UnderwaterCheckBox.pressed
	if underwater:
		save_file(str(directory, "/Overrides/", n, "-inv.txt"), "")
	else:
		save_file(str(directory, "/Overrides/", n, ".txt"), "")
	
	var ob_instance = Globals.override_button.instance()
	$Control/ScrollContainer/VBoxContainer.call_deferred("add_child", ob_instance)
	
	if underwater:
		ob_instance.set_name(str(n, "-inv"))
		ob_instance.text = str(n, "-inv")
	else:
		ob_instance.set_name(n)
		ob_instance.text = n
	
	ob_instance.override_name = ob_instance.text
	
	overrides.append(str(ob_instance.name, ".txt"))



func _on_CancelButton_pressed():
	$NewOverride.hide()
	$NewOverride/OverrideName.text = ""


func _on_OverrideName_text_changed(new_text):
	if new_text == "":
		$NewOverride/CreateButton.disabled = true
	else:
		$NewOverride/CreateButton.disabled = false



func _on_SaveButton_pressed():
	save_all(directory)


func _on_DocsButton_pressed():
	$Docs.show()


func _on_CloseButton_pressed():
	$Docs.hide()


func _on_NewOverride_pressed():
	$NewOverride.show()


func _on_DeleteOverride_pressed():
	if !(selected_file in base_file_names):
		var f = $Control/ScrollContainer/VBoxContainer.get_node(selected_file)
		f.delete()
		$TextEdit.text = ""
		selected_file = ""
		$Bar/DeleteOverride.disabled = true
	


func _on_ColorButton_pressed():
	$ColorPicker.show()


func _on_ColorPickerCloseButton_pressed():
	$ColorPicker.hide()


func _on_CopyRGB_pressed():
	var c = $ColorPicker/ColorPicker.color
	var rgb = str(c.r8, ", ", c.g8, ", ", c.b8)
	OS.set_clipboard(rgb)


func _on_CopyHSV_pressed():
	var c = $ColorPicker/ColorPicker.color
	var hsv = str(c.h, ", ", c.s, ", ", c.v)
	OS.set_clipboard(hsv)

