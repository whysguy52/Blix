extends KinematicBody2D

signal pushing
export var speed = 200 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window
var movement = true
var direction = Vector2()
var velocity = Vector2()

#var animation

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = position.floor()

func controls_loop():
	var LEFT 	= Input.is_action_pressed("ui_left")
	var RIGHT 	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	
	direction.x = -int(LEFT) + int(RIGHT)
	direction.y = -int(UP) + int(DOWN)
	
func movement_loop():
	velocity = direction.normalized() * speed
	movePlayer(velocity)
	if get_slide_count() > 0:
		check_box_collision(velocity)


func _physics_process(delta):
	#if auto-moving
	if movement == false:
		movement_loop()
		animatePlayer(velocity)
		return
	controls_loop()
	movement_loop()
	animatePlayer(velocity) #Must be called. will animate or even STOP animation.

#Moves the player. Used by multiple methods
func movePlayer( velocity : Vector2):
	move_and_slide(velocity, Vector2())
	position.x = clamp(position.x, 16, screen_size.x - 16)
	position.y = clamp(position.y, 16, screen_size.y - 16)
	
	

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
		movement = false
		box.push(velocity)
		

func _on_Box_movementComplete():
	movement = false
	velocity = Vector2(0,0)
	animatePlayer(velocity)
	$PushTimer.start(0)


func _on_PushTimer_timeout():
	movement = true
