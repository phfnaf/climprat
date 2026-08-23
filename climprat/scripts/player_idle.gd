extends Node

var player

func enter():
	# Здесь можно, например, проиграть анимацию покоя
	player.CharacterBody2D.animated_sprite.play("idle")

func exit():
	# Здесь можно сделать что-то при выходе из состояния
	pass

func physics_update(delta):
	# Если нажата клавиша влево/вправо, переключаемся в Run
	if Input.get_axis("left", "right"):
		get_parent().change_to("Run")
	
	# Если нажата клавиша прыжка, переключаемся в Jump
	if Input.is_action_just_pressed("jump"):
		get_parent().change_to("Jump")
