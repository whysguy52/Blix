extends KinematicBody2D

signal pushing
export var speed = 100 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window
var movement = true
var direction = Vector2()
var velocity = Vector2()

#var animation

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	

#pretty much does handles inputs to motion or action
func _physics_process(delta):
	
	#if auto-moving
	if movement == false:
		movePlayer(velocity)
		animatePlayer(velocity)
		return
	else: #calculate movement vectors
		direction = Vector2()   #reset direction
		velocity = Vector2()    #reset velocity
	#check user input
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * speed
		movePlayer(velocity)
	animatePlayer(velocity) #Must be called. will animate or even STOP animation.

#Moves the player. Used by multiple methods
func movePlayer( velocity : Vector2):
	move_and_slide(velocity,Vector2())
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
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
		movement = false
		box.push(velocity)
		

func _on_Box_movementComplete():
	movement = false
	velocity = Vector2(0,0)
	animatePlayer(velocity)
	$PushTimer.start(0)


func _on_PushTimer_timeout():
	movement = true
