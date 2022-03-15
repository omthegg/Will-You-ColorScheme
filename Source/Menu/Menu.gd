extends Node2D

# 050b12

var new_dir
var selected_template:String = "classic"

var copy_files:Array
var other_folders:Array

var excluded_letters = [
	'a',
	'b',
	'c',
	'd',
	'e',
	'f',
	'g',
	'h',
	'i',
	'j',
	'k',
	'l',
	'm',
	'n',
	'o',
	'p',
	'q',
	'r',
	's',
	't',
	'u',
	'v',
	'w',
	'x',
	'y',
	'z',
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H',
	'I',
	'J',
	'K',
	'L',
	'M',
	'N',
	'O',
	'P',
	'Q',
	'R',
	'S',
	'T',
	'U',
	'V',
	'W',
	'X',
	'Y',
	'Z',
	'-',
	'_'
]


var copying_thread = Thread.new()


func _ready():
	pass
	#$Logo/LogoAnimationPlayer.play("LogoColorChange")


func _process(_delta):
	$FileDialog.rect_position = Vector2(-372, -240)
	$NewFileDialog.rect_position = Vector2(-372, -240)

func _on_OpenButton_pressed():
	$FileDialog.window_title = "Open a color scheme folder"
	$FileDialog.popup()


func _on_FileDialog_dir_selected(dir):
	Globals.directory = dir
	var _change = get_tree().change_scene("res://Source/Editor/Editor.tscn")


func _on_NewButton_pressed():
	$NewFileDialog.window_title = "Open the wys 'Colors' folder"
	$NewFileDialog.popup()


func _on_NewFileDialog_dir_selected(dir):
	new_dir = dir
	$ChooseTemplate.show()


func string_to_char_array(s:String):
	var a:Array = []
	for c in s:
		a.append(c)
	return a


func _on_CreateButton_pressed():
	#other_folders.clear()
	#dir_contents(new_dir)
	
	#var number_folders:Array
	#for i in other_folders:
	#	var has_excluded_letters:bool
	#	for j in string_to_char_array(i):
	#		if j in excluded_letters:
	#			has_excluded_letters = true
	#			break
		
	#	if !has_excluded_letters:
	#		number_folders.append(i)
		
	
	#var last_color_scheme:int = 0
	#for i in number_folders:
	#	if int(i) > last_color_scheme:
	#		last_color_scheme = int(i)
	
	create_color_scheme(new_dir, selected_template, $ChooseTemplate/Name.text)


func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				other_folders.append(file_name)
			else:
				print("Found file: " + file_name)
				copy_files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



func copy_cs(args:Array):#cs:int, directory:String, cs_name:String):
	# cs:int, directory:String, cs_name:String
	var cs = args[0]
	var directory = args[1]
	var cs_name = args[2]
	
	copy_files.clear()
	dir_contents(str(new_dir, "/2"))
	
	# Copying the base files
	# Normal, Disco, etc
	for i in copy_files:
		var original_path:String = str(directory, "/", cs, "/", i)
		original_path = original_path.replace("/", "\\")
		var destination_path:String = str(directory, "/", cs_name, "/")
		destination_path = destination_path.replace("/", "\\")
		
		print(OS.execute("xcopy", [original_path, destination_path]))
	
	copy_files.clear()
	dir_contents(str(new_dir, "/", cs,"/Overrides"))
	
	# Copying overrides
	for i in copy_files:
		var original_path:String = str(directory, "/", cs, "/Overrides/", i)
		original_path = original_path.replace("/", "\\")
		var destination_path:String = str(directory, "/", cs_name, "/Overrides/")
		destination_path = destination_path.replace("/", "\\")
		
		print(OS.execute("xcopy", [original_path, destination_path]))
	
	return str(new_dir, "/", cs)



# cs_name means color scheme name.
func create_color_scheme(directory:String, template:String, cs_name:String):
	print(new_dir)
	
	var dir = Directory.new()
	dir.make_dir(str(directory, "/", cs_name))
	dir.make_dir(str(directory, "/", cs_name, "/Overrides"))
	
	if template == "classic":
		print("classic")
		copying_thread.start(self, "copy_cs", [2, directory, cs_name])
		
	elif template == "minimalist":
		print("minimalist")
		copying_thread.start(self, "copy_cs", [3, directory, cs_name])
	
	$ChooseTemplate/CreateButton.disabled = true
	$ChooseTemplate/CancelButton.disabled = true
	
	Globals.directory = copying_thread.wait_to_finish()
	var _change = get_tree().change_scene("res://Source/Editor/Editor.tscn")



func _on_CancelButton_pressed():
	$ChooseTemplate.hide()


func _on_ClassicCheckButton_pressed():
	selected_template = "classic"
	$ChooseTemplate/MinimalistCheckButton.pressed = false


func _on_MinimalistCheckButton_pressed():
	selected_template = "minimalist"
	$ChooseTemplate/ClassicCheckButton.pressed = false


func _on_Name_text_changed(new_text):
	if new_text != "":
		$ChooseTemplate/CreateButton.disabled = false


func _exit_tree():
	if copying_thread.is_active():
		copying_thread.wait_to_finish()


func _on_LogoAnimationPlayer_animation_finished(_anim_name):
	$Logo/LogoAnimationPlayer.play("LogoColorChange")
