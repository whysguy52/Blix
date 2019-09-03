extends KinematicBody2D

signal pushing
export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window
#var animation

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	

func _physics_process(delta):
	var direction = Vector2()
	var velocity = Vector2()
	
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
		move_and_slide(velocity,Vector2())
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
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
	if get_slide_count() > 0:
		check_box_collision(direction)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func check_box_collision(velocity : Vector2):
	if abs(velocity.x) + abs(velocity.y) > 1:
		return
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push(velocity)

