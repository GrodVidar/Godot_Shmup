extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 300

var velocity = Vector2()
var armed_with_gun = false
var armed_with_mg = false
var last_shot = 10
var recoil = 0
var damage = 0
var hp = 100

var Bullet = preload("res://Bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move():
	velocity = Vector2()
	if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		velocity = Vector2(speed/1.5, speed/1.5)
		rotation_degrees = -45
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		velocity = Vector2(-speed/1.5, speed/1.5)
		rotation_degrees = 45
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		velocity = Vector2(speed/1.5, -speed/1.5)
		rotation_degrees = -135
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		velocity = Vector2(-speed/1.5, -speed/1.5)
		rotation_degrees = 135
	elif Input.is_action_pressed("ui_right"):
		velocity = Vector2(speed, 0)
		rotation_degrees = -90
	elif Input.is_action_pressed("ui_left"):
		velocity = Vector2(-speed, 0)
		rotation_degrees = 90
	elif Input.is_action_pressed("ui_down"):
		velocity = Vector2(0, speed)
		rotation_degrees = 0
	elif Input.is_action_pressed("ui_up"):
		velocity = Vector2(0, -speed)
		rotation_degrees = 180

func shoot(time):
	if last_shot > 1:
		var b = Bullet.instance()
		b.start($barrel.global_position, rotation, recoil, damage)
		get_parent().add_child(b)
		last_shot = 0
	last_shot += time * 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()
	if Input.is_action_just_pressed("equip_gun"):
		$barrel.position = Vector2(-21.322, 32)
		armed_with_mg = false
		damage = 10
		recoil = 0
		armed_with_gun = !armed_with_gun
	if Input.is_action_just_pressed("equip_mg"):
		$barrel.position = Vector2(-21.322, 47)
		armed_with_gun = false
		damage = 5
		recoil = .19
		armed_with_mg = !armed_with_mg
	if armed_with_gun:
		if Input.is_action_just_pressed("shoot"):
			shoot(2)
	if armed_with_mg:
		if Input.is_action_pressed("shoot"):
			shoot(delta)
	if velocity.x == 0 and velocity.y == 0:
		if armed_with_gun:
			$AnimatedSprite.play("idle_with_gun")
		elif armed_with_mg:
			$AnimatedSprite.play("idle_with_mg")
		else:
			$AnimatedSprite.play("idle")
	else:
		if armed_with_gun:
			$AnimatedSprite.play("walk_with_gun")
			velocity = move_and_slide(velocity)
		elif armed_with_mg:
			$AnimatedSprite.play("walk_with_mg")
			velocity = move_and_slide(velocity)
		else:
			$AnimatedSprite.play("walk")
			velocity = move_and_slide(velocity)
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
