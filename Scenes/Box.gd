extends Block
class_name Box

export var speed = 32 #pixels/s
var direction = Vector2()
var maxDisplacement = 32
var initialPosition
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PushTimer_timeout():
	var displacement = 0
	initialPosition = position
	while displacement < maxDisplacement:
		move_and_slide(direction * speed, Vector2())
		displacement = position.distance_to(initialPosition)
	$PushTimer.start()


func push(velocity:Vector2):
	direction = velocity.normalized()
	move_and_slide(direction * speed, Vector2())
	
	