extends StaticBody2D

@onready var contenu = {"portes_sortie" : {2 : $porte1}, "potions" : {0 : $ver0}, "pic" : {}, "chest" : {}, "epe" : {}}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# initialise tous les pic dans contenu mettre le nombre du dernier pic plus 1 et bien nommer les pic : 
# pic0, pic2, etc
	for n in range(29):
		contenu["pic"][n] = get_node("pic" + str(n))


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
