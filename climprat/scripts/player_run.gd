extends Node
class_name RunState   # Даём понятное имя классу (опционально)

# Ссылка на игрока (CharacterBody2D) — её установит машина состояний
@onready var player = get_parent().player

# Константы для движения (можно вынести в глобальные настройки)
const SPEED = 300.0
const ACCELERATION = 0.5
const FRICTION = 0.1

# Функция, вызываемая при входе в это состояние
func enter():
	# Проигрываем анимацию бега (если она есть)
	if player.has_method("play_animation"):
		player.play_animation("run")
	
	# Можно также сбросить какие-то флаги, если нужно
	# (например, отменить буфер прыжка и т.п.)
	pass

# Функция, вызываемая при выходе из состояния
func exit():
	# Здесь можно сделать что-то при переходе в другое состояние
	# Например, сбросить частицы, остановить звук бега и т.д.
	pass

# Основная физическая логика (вызывается из state_machine.physics_update)
func physics_update(delta: float):
	# 1. Получаем направление ввода по горизонтали
	var input_dir = Input.get_axis("left", "right")
	
	# 2. Обрабатываем движение (разгон/торможение)
	if input_dir != 0:
		# Если есть ввод, разгоняемся до SPEED с ускорением
		player.velocity.x = move_toward(
			player.velocity.x,
			input_dir * SPEED,
			ACCELERATION * SPEED * delta
		)
	else:
		# Если ввода нет, тормозим с трением
		player.velocity.x = move_toward(
			player.velocity.x,
			0,
			FRICTION * SPEED * delta
		)
	
	# 3. Проверяем условия для перехода в другие состояния
	
	# 3а. Если игрок в воздухе (не на земле) -> переход в Fall
	if not player.is_on_floor():
		get_parent().change_to("Fall")
		return  # Выходим, чтобы не выполнять остальной код
	
	# 3б. Если игрок нажал прыжок -> переход в Jump
	if Input.is_action_just_pressed("jump"):
		get_parent().change_to("Jump")
		return
	
	# 3в. Если ввод по горизонтали отсутствует и скорость близка к нулю -> переход в Idle
	# (опционально, можно оставить на усмотрение, но обычно Idle сам отслеживает это)
	if input_dir == 0 and abs(player.velocity.x) < 10:
		get_parent().change_to("Idle")
		return

	# 4. Если остались в состоянии — применяем движение (физика)
	player.move_and_slide()
