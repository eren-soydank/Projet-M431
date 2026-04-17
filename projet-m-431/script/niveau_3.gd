extends StaticBody2D

@onready var contenu = {"exit_door" : {}, "glass" : {0 : $glass0}, "spike" : {}, "chest" : {0 : $chest0}, "sword" : {}}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialise tous les spike dans contenu mettre le nombre du dernier spike plus 1 et bien nommer les spike : 
	# spike0, spike2, etc
	for n in range(0):
		contenu["spike"][n] = get_node("spike" + str(n))


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
