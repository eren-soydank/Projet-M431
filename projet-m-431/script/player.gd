extends CharacterBody2D
<<<<<<< HEAD
  
=======

>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
# CONSTANTES
const SPEED = 300.0
const KNOCKBACK = 600.0
const JUMP_VELOCITY = -430.0
const DOUBLE_JUMP_VELOCITY = -430.0
<<<<<<< HEAD
const WALL_JUMP_VELOCITY = -430.0
const WALL_SLIDE_SPEED = 130.0
const WALL_JUMP_DURATION = 0.1
=======
const WALL_JUMP_VELOCITY_Y = -400.0
const WALL_JUMP_VELOCITY_X = 280.0
const WALL_SLIDE_SPEED = 60.0
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
const POGO_VELOCITY = -400.0
const ATTACK_DURATION = 0.3
const DASH_SPEED = 600.0
const DASH_DURATION = 0.3
const DRINK_DURATION = 0.3
const INVULNERABLE_DURATION = 1.0

const START_POSITION = Vector2(112.0, -24.0)

const ATTACK_HIT_BOX_SCENE = preload("res://scènes/attack_hit_box.tscn")
const ATTACK_HIT_BOX_POGO_SCENE = preload("res://scènes/attack_hit_box_pogo.tscn")

# VARIABLES
var is_invulnerable = false
var is_attacking = false
<<<<<<< HEAD
=======
var has_knockback = false
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
var is_sliding = false # dash
var is_wall_sliding = false
var is_drinking = false
var has_knockback = false

var invulnerable_timer = 0.0
var dash_timer = 0.0
var attack_timer = 0.0
var drink_timer = 0.0

var can_dash = true
var can_double_jump = true
var glass_number = 0
var hp = 10
<<<<<<< HEAD
=======

var last_direction = 1.0
var dash_direction = 1.0
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
var upgrade_level = 0

var last_direction = 1.0
var wall_direction = 0

<<<<<<< HEAD
=======
var can_double_jump = true
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
var attack_hit_box = null

# SIGNALS
signal use_glass
signal death
signal double_jump_signal

@onready var sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:

	# GRAVITY
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_dash = true
		can_double_jump = true
<<<<<<< HEAD
=======
		is_wall_sliding = false
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8

	var direction := Input.get_axis("move_left", "move_right")
	
	# on met a jour la direction que si il peut bouger
	if direction != 0 and not is_sliding and not is_drinking:
		last_direction = direction
		# le faire bouger
		velocity.x = direction * SPEED
	else:
		# le faire perdre doucement de la vitesse
		velocity.x = move_toward(velocity.x, 0, SPEED)

<<<<<<< HEAD

	# detection de mur
	if is_on_wall():
		# wall_direction est la direction du mur que l'on touche actiellement actuel 1 pour droite, -1 pour gauche 0 pour auqu'un mur
		wall_direction = -sign(get_wall_normal().x)

		if upgrade_level >= 3 and not is_sliding and not is_on_floor():
=======
	# HORIZONTAL MOVE (FIXED: no ground sliding)
	if not is_sliding and not is_drinking:
		if direction != 0:
			last_direction = direction
			velocity.x = direction * SPEED
		else:
			if is_on_floor():
				velocity.x = 0
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	# WALL DETECTION (FIXED)
	if is_on_wall() and not is_on_floor():
		var normal = get_wall_normal()
		wall_direction = -1 if normal.x > 0 else 1

		if upgrade_level >= 3 and not is_sliding and not is_drinking:
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
			is_wall_sliding = true
			last_direction = -wall_direction
			velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
			can_dash = true
			can_double_jump = true
		else:
			is_wall_sliding = false
<<<<<<< HEAD
			
	else:
		wall_direction = 0
		is_wall_sliding = false
	
	jump()
	double_jump()
	wall_jump(delta)

=======
	else:
		wall_direction = 0
		is_wall_sliding = false

	jump()
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
	attack(delta)
	regen(delta)
	dash(delta)

	move_and_slide()
<<<<<<< HEAD

	couldown_invulnerable(delta)
	animations(direction)
	
# ---------------- JUMP ----------------
func jump():
	if Input.is_action_just_pressed("jump") and not is_sliding and not is_drinking and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
# ---------------- DOUBLE JUMP ----------------
func double_jump():
	if Input.is_action_just_pressed("jump") and upgrade_level >= 4 and not is_sliding and not is_on_floor() and can_double_jump and not is_wall_sliding:
		velocity.y = DOUBLE_JUMP_VELOCITY
		can_double_jump = false
		
		if sprite.animation == "jump":
			sprite.play("jump")
=======

	couldown_invulnerable(delta)
	animations(direction)


# ---------------- JUMP ----------------
func jump():
	if Input.is_action_just_pressed("jump") and not is_sliding and not is_drinking:

		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		elif upgrade_level >= 3 and wall_direction != 0:
			velocity.y = WALL_JUMP_VELOCITY_Y
			velocity.x = -wall_direction * WALL_JUMP_VELOCITY_X
			last_direction = -wall_direction
			can_double_jump = false
			is_wall_sliding = false
			emit_signal("double_jump")

		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false
			emit_signal("double_jump")
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8

		# envoi un signal à main pour faire aparaitre le nuage
		emit_signal("double_jump_signal")
		
# ---------------- WALL JUMP ----------------
func wall_jump(delta):
	if Input.is_action_just_pressed("jump") and is_wall_sliding:
		velocity.y = WALL_JUMP_VELOCITY

# ---------------- ATTACK ----------------
func attack(delta):

	if has_knockback:
		velocity.x = -last_direction * KNOCKBACK
	has_knockback = false

<<<<<<< HEAD
	if Input.is_action_just_pressed("attack") and upgrade_level >= 1 and not is_attacking and not is_drinking:
=======
	if Input.is_action_just_pressed("attack") and upgrade_level >= 1 and not is_attacking and not is_drinking and not is_wall_sliding:
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8

		is_attacking = true
		attack_timer = ATTACK_DURATION

		if attack_hit_box == null:
<<<<<<< HEAD
			if Input.is_action_pressed("down") and not is_on_floor() and not is_wall_sliding:
=======
			if Input.is_action_pressed("down") and not is_on_floor():
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
				attack_hit_box = ATTACK_HIT_BOX_POGO_SCENE.instantiate()
			else:
				attack_hit_box = ATTACK_HIT_BOX_SCENE.instantiate()

			add_child(attack_hit_box)
			attack_hit_box.connect("touch", _touch)

	if is_attacking:
		attack_timer -= delta

		if attack_hit_box != null:

			if attack_timer <= 0:
				end_attack()

			else:
				attack_hit_box.get_node("AnimatedSprite2D").flip_h = last_direction < 0

				if attack_hit_box.name == "attack_hit_box_pogo":
					attack_hit_box.global_position = global_position + Vector2(0, 27)
				elif last_direction == 1:
					attack_hit_box.global_position = global_position + Vector2(30, -3)
				else:
					attack_hit_box.global_position = global_position + Vector2(-30, -3)


func end_attack():
	is_attacking = false
	if attack_hit_box:
		attack_hit_box.queue_free()
		attack_hit_box = null


# ---------------- REGEN ----------------
func regen(delta):

	if Input.is_action_pressed("regen") and glass_number > 0 and hp < 10 and not is_drinking and not is_attacking and not is_sliding and is_on_floor():

		hp += 1
		glass_number -= 1
		emit_signal("use_glass")

		is_drinking = true
		drink_timer = DRINK_DURATION

	if is_drinking:
		drink_timer -= delta
		if drink_timer <= 0:
			is_drinking = false


# ---------------- DASH (FIXED) ----------------
func dash(delta):

	if Input.is_action_just_pressed("dash") and upgrade_level >= 2 and not is_sliding and not is_drinking and can_dash:
<<<<<<< HEAD
		if not is_on_floor() and is_sliding:
			can_dash = false
			
		is_sliding = true
		dash_timer = DASH_DURATION

		if not is_on_floor() and wall_direction == 0:
			can_dash = false

=======

		is_sliding = true
		is_wall_sliding = false
		dash_timer = DASH_DURATION

		# FIX: correct dash direction
		if is_on_wall() and not is_on_floor():
			dash_direction = -wall_direction
		else:
			dash_direction = last_direction

		if not is_on_floor() and wall_direction == 0:
			can_dash = false

>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
	if is_sliding:

		dash_timer -= delta

<<<<<<< HEAD
		if dash_timer <= 0 or wall_direction == last_direction:
=======
		if dash_timer <= 0:
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
			end_dash()
		else:
			velocity.y = 0
			velocity.x = dash_direction * DASH_SPEED



func end_dash():
	is_sliding = false


# ---------------- INVULNERABLE ----------------
func couldown_invulnerable(delta):

	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false


# ---------------- ANIMATIONS ----------------
func animations(direction):
<<<<<<< HEAD
	sprite.flip_h = last_direction < 0
=======

	if is_wall_sliding:
		sprite.flip_h = wall_direction > 0
	else:
		sprite.flip_h = last_direction < 0
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8

	if is_sliding:
		if sprite.animation != "dash":
			sprite.play("dash")

<<<<<<< HEAD
	elif is_attacking:
=======
	if is_wall_sliding:
		if sprite.animation != "wall_slide":
			sprite.play("wall_slide")
		return

	if is_attacking:
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
		if attack_hit_box:
			if attack_hit_box.name == "attack_hit_box_pogo":
				sprite.play("attack_pogo")
			else:
				sprite.play("attack")
<<<<<<< HEAD
				
	elif is_wall_sliding:
		if sprite.animation != "wall_slide":
			sprite.play("wall_slide")
=======
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
			
	elif is_drinking:
		if sprite.animation != "drinking":
			sprite.play("drinking")

	elif not is_on_floor():
		if sprite.animation != "jump":
			sprite.play("jump")
<<<<<<< HEAD

	elif direction != 0:
=======
		return

	if direction != 0:
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
		sprite.play("walk")
	else:
		sprite.play("idle")


# ---------------- DAMAGE ----------------
func prendre_dega(number):

	if not is_invulnerable:

		hp -= number

		if hp <= 0:
			hp = 0
			dead()

		is_invulnerable = true
		invulnerable_timer = INVULNERABLE_DURATION


func dead():
	hp = 10
	glass_number = 0
	upgrade_level = 0
	emit_signal("death")


# ---------------- POGO / HIT ----------------
func _touch(is_pogo):

	if is_pogo:
		velocity.y = POGO_VELOCITY
		can_dash = true
		can_double_jump = true
	else:
		has_knockback = true
