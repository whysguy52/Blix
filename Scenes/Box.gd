extends Block
class_name Box

signal movementComplete
var screen_size # Size of the game window
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
	screen_size = get_viewport_rect().size
	position = position.floor()
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
	
	if initialPosition.x == -1:
		initialPosition = position
		
	#calculate the diplacement
	direction = velocity.normalized()
	move_and_slide(direction * speed, Vector2())
	
	position.x = clamp(position.x, 16, screen_size.x - 16)
	position.y = clamp(position.y, 16, screen_size.y - 16)
	
	displacement = position.distance_to(initialPosition)
	
	if displacement >= maxDisplacement: #|| isOutsideClamp(position) :
		position = position.floor()
		print (position)
		emit_signal("movementComplete")
		initialPosition.x = -1
		displacement = 0
		return
		
func isOutsideClamp(position : Vector2):
	if position.x < 0 || position.x > screen_size.x || position.y < 0 || position.y > screen_size.y:
		
		return true
	else:
		return false
	