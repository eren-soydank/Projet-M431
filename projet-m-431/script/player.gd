extends CharacterBody2D
# j'ai permi de faire des slide en l'aire
# l'attaque dois etre déblocker au niveau 1
# le dash (slide) devrait etre déblocker au niveau 1
const SPEED = 300.0
const JUMP_VELOCITY = -430.0
const ATTACK_DURATION = 0.3
const SLIDE_SPEED = 600.0
const SLIDE_DURATION = 0.3
const START_POSITION = Vector2(94.0, -76.0)
@onready var sprite = $AnimatedSprite2D
var is_attacking = false
var is_sliding = false
var slide_direction = 0
var slide_timer = 0.0
var attack_timer = 0.0
var can_slide = true
var glass_number = 0
var hp = 10
var last_direction = 1.0
var upgrade_level = 0
var wall_direction = 0
signal use_glass
signal death

func _physics_process(delta: float) -> void:
	if is_on_wall():
		wall_direction = -sign(get_wall_normal().x)
	else:
		wall_direction = 0
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_slide = true

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_sliding and not is_attacking:
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0 and !is_sliding:
		last_direction = direction

	# Attack input — cannot attack while sliding
	if Input.is_action_just_pressed("attack") and not is_sliding and not is_attacking:
		is_attacking = true
		attack_timer = ATTACK_DURATION
		sprite.flip_h = last_direction < 0
		sprite.play("attack")

	# Attack timer countdown
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false

	if Input.is_action_just_pressed("slide") and not is_sliding and not is_attacking and can_slide:
		if not is_on_floor():
			can_slide = false
		is_sliding = true
		slide_direction = last_direction
		slide_timer = SLIDE_DURATION
		sprite.flip_h = slide_direction < 0

	if is_sliding:
		velocity.y = 0
		slide_timer -= delta
		if slide_timer <= 0 or wall_direction == slide_direction:
			is_sliding = false
		velocity.x = slide_direction * SLIDE_SPEED
	else:
		if direction != 0:
			velocity.x = direction * SPEED
			if not is_attacking:
				sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("regen") and glass_number > 0 and hp < 10:
		hp += 1
		glass_number -= 1
		emit_signal("use_glass")

	move_and_slide()

	# Animation priority: slide > attack > jump > walk/idle
	if is_sliding:
		if sprite.animation != "slide":
			sprite.play("slide")
		return

	if is_attacking:
		# Keep playing attack — don't interrupt it
		return

	if not is_on_floor():
		if sprite.animation != "jump":
			sprite.play("jump")
		return

	if direction != 0:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

func prendre_dega(number):
	hp -= number
	if hp <= 0:
		hp = 0
		dead()

func dead():
	hp = 10
	glass_number = 0
	emit_signal("death")
