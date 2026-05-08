extends CharacterBody2D

# j'ai permi de faire des slide en l'aire
# l'attaque dois etre déblocker au niveau 1
# le dash (slide) devrait etre déblocker au niveau 1
const SPEED = 300.0
const JUMP_VELOCITY = -430.0
const DOUBLE_JUMP_VELOCITY = -430.0
const ATTACK_DURATION = 0.1
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
var can_double_jump = true

signal use_glass
signal death
signal double_jump

func _physics_process(delta: float) -> void:
	if is_on_wall():
		wall_direction = -sign(get_wall_normal().x)
	else:
		wall_direction = 0

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_slide = true
		can_double_jump = true
	
	if Input.is_action_just_pressed("jump") and not is_sliding:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false
			# juste pour que l'animation de saut ce refasse
			sprite.play("idle")
			emit_signal("double_jump")
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0 and !is_sliding:
		last_direction = direction
	
	if Input.is_action_just_pressed("slide") and not is_sliding and can_slide:
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
			sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# si la touche Q est presser et que il a un ver et que ces hp ne sont pas au max
	if Input.is_action_just_pressed("regen") and glass_number > 0 and hp < 10:
		# gagne un coeur
		hp += 1
		# perd un ver
		glass_number -= 1
		# envoi un signal a main ver la fonction _use_glass
		emit_signal("use_glass")
		
	move_and_slide()
	
	if is_sliding:
		if sprite.animation != "slide":
			sprite.play("slide")
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
	# si la vie dessand en dessou de 0
	if hp <= 0:
		hp = 0
		dead()
	
func dead():
	# on recommance au niveau 1
	hp = 10
	glass_number = 0
	# envoi un signal a main ver la fonction _death
	emit_signal("death")
