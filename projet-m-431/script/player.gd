extends CharacterBody2D
# l'attaque dois etre débloquer au niveau 1
# le dash (slide) devrait etre débloquer au niveau 2
const SPEED = 300.0
const KNOCKBACK = 600.0
const JUMP_VELOCITY = -430.0
const DOUBLE_JUMP_VELOCITY = -430.0
const POGO_VELOCITY = -350.0
const ATTACK_DURATION = 0.3
const SLIDE_SPEED = 600.0
const SLIDE_DURATION = 0.3
const DRINK_DURATION = 0.3
const START_POSITION = Vector2(94.0, -76.0)
const ATTACK_HIT_BOX_SCENE = preload("res://scènes/attack_hit_box.tscn")
const ATTACK_HIT_BOX_POGO_SCENE = preload("res://scènes/attack_hit_box_pogo.tscn")
const INVULNERABLE_DURATION = 1.0
@onready var sprite = $AnimatedSprite2D
var is_invulnerable = false
var is_attacking = false
var hase_knockback = false
var is_sliding = false
var is_drinking = false
var invulnerable_timer = 0.0
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
	
	# detection de mur
	if is_on_wall():
		wall_direction = -sign(get_wall_normal().x)
	else:
		wall_direction = 0
	
	# detection du sol
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_slide = true
		can_double_jump = true
	
	# recuperation de la direction et mouvement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0 and not is_sliding and not is_drinking:
		last_direction = direction
		
	if direction != 0 and not is_sliding and not is_drinking:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	jump()

	attack(delta)
	
	regen(delta)
	
	slide(delta)

	# bouger
	move_and_slide()
	
	couldown_invulnerable(delta)

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
			
func attack(delta):
	if hase_knockback:
		velocity.x = - last_direction * KNOCKBACK
	hase_knockback = false
	# Ne peut pas attaquer en slideant
	if Input.is_action_just_pressed("attack") and upgrade_level >= 1 and not is_sliding and not is_attacking and not is_drinking:
		is_attacking = true
		attack_timer = ATTACK_DURATION
		if attack_hit_box == null:
			if Input.is_action_pressed("down") and not is_on_floor():
				# instansier la hit-box
				attack_hit_box = ATTACK_HIT_BOX_POGO_SCENE.instantiate()
				
			else:
				# instansier la hit-box
				attack_hit_box = ATTACK_HIT_BOX_SCENE.instantiate()
			# l'ajouter comme node enfant du niveau
			add_child(attack_hit_box)
			attack_hit_box.connect("touch", _touch)
	
	# Attack cooldown
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0 or (attack_hit_box.name == "attack_hit_box_pogo" and is_on_floor()):
			end_attack()
				
		elif attack_hit_box != null:
			attack_hit_box.get_node("AnimatedSprite2D").flip_h = last_direction < 0
			# le repositionner en fonction de la position de la position et de la direction
			if attack_hit_box.name == "attack_hit_box_pogo":
				attack_hit_box.global_position = Vector2(global_position.x + 20, global_position.y + 80)
			elif last_direction == 1:
				attack_hit_box.global_position = Vector2(global_position.x + 50, global_position.y + 50)
			else:
				attack_hit_box.global_position = Vector2(global_position.x - 10, global_position.y + 50)

func end_attack():
	is_attacking = false
	if attack_hit_box != null:
		attack_hit_box.queue_free()
		attack_hit_box = null
		
func regen(delta):
	# Regen — déclenche l'animation de boisson, le soin se fait au début
	if Input.is_action_just_pressed("regen") and glass_number > 0 and hp < 10 and not is_drinking and not is_attacking and not is_sliding and is_on_floor():
		hp += 1
		glass_number -= 1
		emit_signal("use_glass")
		is_drinking = true
		drink_timer = DRINK_DURATION
	
	# Drink cooldown
	if is_drinking:
		drink_timer -= delta
		if drink_timer <= 0:
			is_drinking = false
	
func slide(delta):
	if Input.is_action_just_pressed("slide") and upgrade_level >= 2 and not is_sliding and not is_drinking and can_slide:
		if not is_on_floor():
			can_slide = false
		is_sliding = true
		slide_direction = last_direction
		slide_timer = SLIDE_DURATION
		sprite.flip_h = slide_direction < 0
	
	# slide cooldown
	if is_sliding:
		velocity.y = 0
		slide_timer -= delta
		if slide_timer <= 0 or wall_direction == slide_direction:
			end_slide()
		velocity.x = slide_direction * SLIDE_SPEED

func end_slide():
	is_sliding = false

func animations(direction):
	if not is_drinking and not is_sliding:
		sprite.flip_h = last_direction < 0
		
	# Priorité d'animation: slide > attack > drinking > jump > walk et idle
	if is_sliding:
		if sprite.animation != "slide":
			sprite.play("slide")
		return

	if is_attacking:
		if sprite.animation != "attack_pogo" and attack_hit_box.name == "attack_hit_box_pogo":
			sprite.play("attack_pogo")
		elif sprite.animation != "attack" and attack_hit_box.name == "attack_hit_box":
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
	if not is_invulnerable:
		hp -= number
		end_slide()
		end_attack()
		if hp <= 0:
			hp = 0
			dead()
		is_invulnerable = true
		invulnerable_timer = INVULNERABLE_DURATION

func dead():
	hp = 10
	glass_number = 0
	upgrade_level = 0
	end_slide()
	end_attack()
	emit_signal("death")

func couldown_invulnerable(delta):
	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false

func _touch(is_pogo):
	if is_pogo:
		velocity.y = POGO_VELOCITY
		can_slide = true
		can_double_jump = true
	else:
		hase_knockback = true
