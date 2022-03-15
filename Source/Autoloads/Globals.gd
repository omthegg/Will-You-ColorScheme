extends Node


var editor:Node2D
var editor_textedit:TextEdit
var editor_filename:Label

var directory:String

var override_button = preload("res://Source/OverrideButton/OverrideButton.tscn")

func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
