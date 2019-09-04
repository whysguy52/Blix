extends Block
class_name Box

signal movementComplete
export var speed = 32 #pixels/s
var direction = Vector2()
var maxDisplacement = 32
var initialPosition = Vector2()

var displacement = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	initialPosition.x = -1
	initialPosition.y = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PushTimer_timeout():
	
	move_and_slide(direction * speed, Vector2())
	displacement = position.distance_to(initialPosition)
	$PushTimer.start()


func push(velocity:Vector2):
	# Set initial position
	if initialPosition.x == -1:
		initialPosition = position
	#calculate the diplacement
	direction = velocity.normalized()
	move_and_slide(direction * speed, Vector2())
	displacement = position.distance_to(initialPosition)
	if displacement >= maxDisplacement:
		emit_signal("movementComplete")
		print("Movement Complete")
		initialPosition.x = -1
	
	