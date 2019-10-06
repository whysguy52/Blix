extends KinematicBody2D

export var speed = 200 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window
var direction = Vector2()
var velocity = Vector2()

#var animation

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = position.floor()

# warning-ignore:unused_argument
func _physics_process(delta):
	controls_loop()
	movement_loop()
	animatePlayer(velocity) #Must be called. will animate or even STOP animation.

func controls_loop():
	var LEFT 	= Input.is_action_pressed("ui_left")
	var RIGHT 	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	
	direction.x = -int(LEFT) + int(RIGHT)
	direction.y = -int(UP) + int(DOWN)
	
func movement_loop():
	velocity = direction.normalized() * speed
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2())
	position.x = clamp(position.x, 16, screen_size.x - 16)
	position.y = clamp(position.y, 16, screen_size.y - 16)
	if get_slide_count() > 0:
		check_box_collision(velocity)
	
func animatePlayer(velocity : Vector2):
	if velocity.x != 0:
		if velocity.x > 0:
			$AnimationPlayer.current_animation = "SideWalk"
			$Sprite.flip_h = true
		else:
			$AnimationPlayer.current_animation = "SideWalk"
			$Sprite.flip_h = false
	elif velocity.y != 0:
		if velocity.y > 0:
			$AnimationPlayer.current_animation = "DownWalk"
		else:
			$AnimationPlayer.current_animation = "UpWalk"
	else:
		var current_anim = $AnimationPlayer.current_animation
		if current_anim == "SideWalk":
			$AnimationPlayer.current_animation = "SideStill"
		elif current_anim == "DownWalk":
			$AnimationPlayer.current_animation = "DownStill"
		elif current_anim == "UpWalk":
			$AnimationPlayer.current_animation = "UpStill"
	

func check_box_collision(velocity : Vector2):
	if abs(direction.x) + abs(direction.y) > 1:
		return
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push(velocity)
		print( "Collision With Box")
		
