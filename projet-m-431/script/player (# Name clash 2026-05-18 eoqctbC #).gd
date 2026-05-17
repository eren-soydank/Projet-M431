extends CharacterBody2D
# j'ai permi de faire des slide en l'aire
# l'attaque dois etre débloquer au niveau 1
# le dash (slide) devrait etre débloquer au niveau 1
const SPEED = 300.0
const JUMP_VELOCITY = -430.0
const DOUBLE_JUMP_VELOCITY = -430.0
const ATTACK_DURATION = 0.4
const SLIDE_SPEED = 600.0
const SLIDE_DURATION = 0.3
const DRINK_DURATION = 0.3
const START_POSITION = Vector2(94.0, -76.0)
@onready var sprite = $AnimatedSprite2D
var is_attacking = false
var is_sliding = false
var is_drinking = false
var slide_direction = 0
var slide_timer = 0.0
var attack_timer = 0.0
var drink_timer = 0.0
var can_slide = true
var glass_number = 0
var hp = 10
var last_direction = 1.0
var upgrade_level = 0
var wall_direction = 0
var can_double_jump = true
var attack_hit_box = null

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
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0 and not is_sliding and not is_drinking:
		last_direction = direction
		
	if direction != 0 and not is_sliding and not is_drinking:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	jump()

	attack()

	regen()
	
	slide()
	
	# Attack cooldown
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			if attack_hit_box != null:
				# attack_hit_box.queue_free()
				attack_hit_box = null
		elif attack_timer <= 0.3 and attack_hit_box == null:
			# chercher l'objet attack_hit_box
			var attack_hit_box_scene = preload("res://scènes/attack_hit_box.tscn")
			# l'instansier
			attack_hit_box = attack_hit_box_scene.instantiate()
			# l'ajouter comme node enfant du niveau
			add_child(attack_hit_box)
		if attack_hit_box != null:
			attack_hit_box.get_node("Sprite2D").flip_h = last_direction < 0
			# le repositionner en fonction de la position de la position et de la direction
			if last_direction == 1:
				attack_hit_box.global_position = Vector2(global_position.x + 50, global_position.y + 50)
			else:
				attack_hit_box.global_position = Vector2(global_position.x - 10, global_position.y + 50)

	# Drink cooldown
	if is_drinking:
		drink_timer -= delta
		if drink_timer <= 0:
			is_drinking = false
	
	# slide cooldown
	if is_sliding:
		velocity.y = 0
		slide_timer -= delta
		if slide_timer <= 0 or wall_direction == slide_direction:
			is_sliding = false
		velocity.x = slide_direction * SLIDE_SPEED

	# bouger
	move_and_slide()

	animations(direction)

func jump():
	if Input.is_action_just_pressed("jump") and not is_sliding and not is_drinking:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false
			# juste pour que l'animation de saut ce refasse
			# pour eviter que ca interompe une autre animation
			if sprite.animation == "jump":
				sprite.play("idle")
			emit_signal("double_jump")
			
func attack():
	# Ne peut pas attaquer en slideant
	if Input.is_action_just_pressed("attack") and not is_sliding and not is_attacking and not is_drinking:
		is_attacking = true
		attack_timer = ATTACK_DURATION

func regen():
	# Regen — déclenche l'animation de boisson, le soin se fait au début
	if Input.is_action_just_pressed("regen") and glass_number > 0 and hp < 10 and not is_drinking and not is_attacking and not is_sliding and is_on_floor():
		hp += 1
		glass_number -= 1
		emit_signal("use_glass")
		is_drinking = true
		drink_timer = DRINK_DURATION
		
func slide():
	if Input.is_action_just_pressed("slide") and not is_sliding and not is_drinking and can_slide:
		if not is_on_floor():
			can_slide = false
		is_sliding = true
		slide_direction = last_direction
		slide_timer = SLIDE_DURATION
		sprite.flip_h = slide_direction < 0

func animations(direction):
	if not is_drinking and not is_sliding:
		sprite.flip_h = last_direction < 0
		
	# Priorité d'animation: slide > attack > drinking > jump > walk et idle
	if is_sliding:
		if sprite.animation != "slide":
			sprite.play("slide")
		return

	if is_attacking:
		if sprite.animation != "attack":
			sprite.play("attack")
		return

	if is_drinking:
		if sprite.animation != "drinking":
			sprite.play("drinking")
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
