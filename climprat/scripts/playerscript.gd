extends CharacterBody2D

@onready var state_machine = $StateMachine

func _ready():
	state_machine.init(self)

func _physics_process(delta):
	state_machine.physics_update(delta)

func _unhandled_input(event):
	state_machine.input(event)
