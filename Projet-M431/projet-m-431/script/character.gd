extends CharacterBody2D

# j'ai permi de faire des slide en l'aire
# l'attaque dois etre déblocker au niveau 1
# le dash (slide) devrait etre déblocker au niveau 1
const SPEED = 300.0
const JUMP_VELOCITY = -430.0
const SLIDE_SPEED = 600.0
const SLIDE_DURATION = 0.3
const START_POSITION = Vector2(94.0, -76.0)

@onready var sprite = $AnimatedSprite2D

var is_sliding = false
var slide_direction = 0
var slide_timer = 0.0
var can_slide = true
var nombre_potion = 0
var vie = 10
var derniere_direction = 1.0
var niveua_amelioration = 0

signal utilise_potion
signal mort

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_slide = true
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_sliding:
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		derniere_direction = direction
	
	if Input.is_action_just_pressed("slide") and not is_sliding and can_slide:
		if not is_on_floor():
			can_slide = false
		is_sliding = true
		slide_direction = derniere_direction
		slide_timer = SLIDE_DURATION
		sprite.flip_h = slide_direction < 0
	
	if is_sliding:
		velocity.y = 0
		slide_timer -= delta
		if slide_timer <= 0:
			is_sliding = false
		velocity.x = slide_direction * SLIDE_SPEED
	else:
		if direction != 0: 
			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	if Input.is_action_just_pressed("regen") and nombre_potion > 0 and vie < 10:
		vie += 1
		nombre_potion -= 1
		emit_signal("utilise_potion")
		
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

func prendre_dega(nombre):
	vie -= nombre
	# si la vie dessand en dessou de 0
	if vie <= 0:
		vie = 0
		mourir()
	
func mourir():
	# on recommance au niveau 1
	vie = 10
	nombre_potion = 0
	# envoi un signal a main ver la fonction _mort
	emit_signal("mort")
