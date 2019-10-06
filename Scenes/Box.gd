extends Block
class_name Box

signal movementComplete
var screen_size # Size of the game window
export var speed = 40 #pixels/s
var direction = Vector2()
var maxDisplacement = 32
var initialPosition = Vector2()

var displacement = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = position.floor()
	initialPosition.x = -1
	initialPosition.y = -1
	print("(" + str(position.x) + "," + str(position.y) + ")")

func _on_PushTimer_timeout():
	move_and_slide(direction * speed, Vector2())
	displacement = position.distance_to(initialPosition)
	$PushTimer.start()

func push(velocity:Vector2):
	move_and_slide(velocity.normalized() * speed, Vector2())
	
	position.x = clamp(position.x, 16, screen_size.x - 16)
	position.y = clamp(position.y, 16, screen_size.y - 16)
	
	