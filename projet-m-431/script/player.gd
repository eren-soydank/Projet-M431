extends CharacterBody2D

# les constantes
const SPEED = 300.0
const KNOCKBACK = 600.0
const JUMP_VELOCITY = -430.0
const DOUBLE_JUMP_VELOCITY = -430.0
const POGO_VELOCITY = -400.0
const ATTACK_DURATION = 0.3
const DASH_SPEED = 600.0
const DASH_DURATION = 0.3
const DRINK_DURATION = 0.3
const START_POSITION = Vector2(112.0, -24.0)
const ATTACK_HIT_BOX_SCENE = preload("res://scènes/attack_hit_box.tscn")
const ATTACK_HIT_BOX_POGO_SCENE = preload("res://scènes/attack_hit_box_pogo.tscn")
const INVULNERABLE_DURATION = 1.0

# les variables
var is_invulnerable = false
var is_attacking = false
var hase_knockback = false
var is_sliding = false
var is_drinking = false
var invulnerable_timer = 0.0
var dash_timer = 0.0
var attack_timer = 0.0
var drink_timer = 0.0
var can_dash = true
var glass_number = 0
var hp = 10
var last_direction = 1.0
var upgrade_level = 0
var wall_direction = 0
var can_double_jump = true
var attack_hit_box = null

# les signaux
signal use_glass
signal death
signal double_jump

# recupérer les sous nodes importants
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# si il est sur le sol
	if is_on_floor():
		can_dash = true
		can_double_jump = true
	# si non
	else:
		# le faire tomber
		velocity += get_gravity() * delta
	
	# recuperation de la direction et mouvement
	var direction := Input.get_axis("move_left", "move_right")
	
	# on met a jour la direction que si il peut bouger
	if direction != 0 and not is_sliding and not is_drinking:
		last_direction = direction
		# le faire bouger
		velocity.x = direction * SPEED
	else:
		# le faire perdre doucement de la vitesse
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# detection de mur
	if is_on_wall():
		# wall_direction est la direction du mur que l'on touche actiellement actuel 1 pour droite, -1 pour gauche 0 pour auqu'un mur
		wall_direction = -sign(get_wall_normal().x)
		
		if upgrade_level >= 3 and not is_on_floor() and not is_sliding:
			can_dash = true
			can_double_jump = true
			last_direction = -wall_direction
	else:
		wall_direction = 0
	
	# detection du saut
	jump()
	
	# detection de l'attaque
	attack(delta)
	
	# detection de la regénération
	regen(delta)
	
	# detection des dash
	dash(delta)

	# la fonction du système qui gère les mouvements et la vitesse
	move_and_slide()
	
	# la fonction pour ne pas prendre deux degat d'affilé
	couldown_invulnerable(delta)
	
	# la gerion des animations et des prioritées d'animations
	animations(direction)

func jump():
	# si il peut sauter
	if Input.is_action_just_pressed("jump") and not is_sliding and not is_drinking:
		# si il est sur le sol
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		# si il peut double sauter
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			# pour qu'il ne puisse pas double sauter plusieur fois sant toucher le sol
			if not is_on_floor():
				can_double_jump = false
				
			# juste pour que l'animation de saut ce refasse
			# pour eviter que ca interompe une autre animation
			if sprite.animation == "jump":
				sprite.play("idle")
			# envoi un signal à main pour faire aparaitre le nuage
			emit_signal("double_jump")
			
func attack(delta):
	# le recule ce fait a la fonction qui resoi le signal de l'attaque hit box
	if hase_knockback:
		velocity.x = - last_direction * KNOCKBACK
	hase_knockback = false
	# si il peut attaquer
	if Input.is_action_just_pressed("attack") and upgrade_level >= 1 and not is_attacking and not is_drinking:
		is_attacking = true
		# lance le temp de l'attaque
		attack_timer = ATTACK_DURATION
		# si il n'y a pas dejat une attaque hit box
		if attack_hit_box == null:
			# si il veut faire un pogo
			if Input.is_action_pressed("down") and not is_on_floor():
				# instansier la hit-box-pogo
				attack_hit_box = ATTACK_HIT_BOX_POGO_SCENE.instantiate()
			else:
				# instansier la hit-box
				attack_hit_box = ATTACK_HIT_BOX_SCENE.instantiate()
			# l'ajouter comme node enfant du niveau
			add_child(attack_hit_box)
			# lier le signal de toucher a la fonction "_touch"
			attack_hit_box.connect("touch", _touch)
	
	# Attack cooldown
	if is_attacking:
		attack_timer -= delta
		# si l'attaque est fini
		if attack_timer <= 0 or (attack_hit_box.name == "attack_hit_box_pogo" and is_on_floor()):
			end_attack()
			
		elif attack_hit_box != null:
			# faire retourner l'immage de l'attaque en fonction de la ou tu regarde
			attack_hit_box.get_node("AnimatedSprite2D").flip_h = last_direction < 0
			
			# le repositionner en fonction de la position de la position et de la direction
			if attack_hit_box.name == "attack_hit_box_pogo":
				attack_hit_box.global_position = Vector2(global_position.x, global_position.y + 27)
			elif last_direction == 1:
				attack_hit_box.global_position = Vector2(global_position.x + 30, global_position.y - 3)
			else:
				attack_hit_box.global_position = Vector2(global_position.x - 30, global_position.y - 3)

func end_attack():
	is_attacking = false
	
	# si la hit box de l'attaque exsiste encore
	if attack_hit_box != null:
		# on la supprime
		attack_hit_box.queue_free()
		attack_hit_box = null
		
func regen(delta):
	# Regen — déclenche l'animation de boisson, le soin se fait au début
	# on peut mintenant laisser la touche appuier pour ce regénérer intégralement
	if Input.is_action_pressed("regen") and glass_number > 0 and hp < 10 and not is_drinking and not is_attacking and not is_sliding and is_on_floor():
		hp += 1
		glass_number -= 1
		# envoi un signal a main pour mettre a jour le nombre de coeur dans hud
		emit_signal("use_glass")
		is_drinking = true
		# lance le timer de la regénération
		drink_timer = DRINK_DURATION
	
	# Drink cooldown
	if is_drinking:
		drink_timer -= delta
		if drink_timer <= 0:
			is_drinking = false
	
func dash(delta):
	# si on peut dash
	if Input.is_action_just_pressed("dash") and upgrade_level >= 2 and not is_sliding and not is_drinking and can_dash:
		# si il n'as pas commancer le dash sur le sol il ne peut plus dash tant qu'il n'est plus sur le sol
		if not is_on_floor() and (not is_on_wall() or upgrade_level < 3):
			can_dash = false
			
		is_sliding = true
		
		# commancer le timer du dash
		dash_timer = DASH_DURATION
	
	# dash cooldown
	if is_sliding:
		dash_timer -= delta
		# si le timer est fini ou que l'on ce prend un mur on stop le dash
		if dash_timer <= 0 or wall_direction == last_direction:
			end_dash()
		else:
			velocity.y = 0
			velocity.x = last_direction * DASH_SPEED

func end_dash():
	is_sliding = false
	
func couldown_invulnerable(delta):
	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false
			
func animations(direction):
	sprite.flip_h = last_direction < 0
		
	# Priorité d'animation: dash > attack > drinking > jump > walk et idle
	if is_sliding:
		if sprite.animation != "dash":
			sprite.play("dash")
		return

	if is_attacking:
		# si c'est un pogo
		if sprite.animation != "attack_pogo" and attack_hit_box.name == "attack_hit_box_pogo":
			sprite.play("attack_pogo")
		# si c'est une attaque normal
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
	# si il n'as pas pris de degat récemment
	if not is_invulnerable:
		hp -= number
		# si il a plus de vies
		if hp <= 0:
			hp = 0
			dead()
		is_invulnerable = true
		# lance le timer d'invulnérabilité (1seconde)
		invulnerable_timer = INVULNERABLE_DURATION

func dead():
	# retrouve ses vies
	hp = 10
	# perd ces potions
	glass_number = 0
	# perd ses capacité de déplacement
	upgrade_level = 0
	# envoi un signal a main pour changer de niveau,  mettre a jour l'hud, et tp le joueur
	emit_signal("death")

# si l'attaque touche
func _touch(is_pogo):
	# si c'est un pogo
	if is_pogo:
		# rebondit
		velocity.y = POGO_VELOCITY
		# peut re-silide et double sauter
		can_dash = true
		can_double_jump = true
	# si c'est une attaque normal il y a un léger recule
	else:
		hase_knockback = true
