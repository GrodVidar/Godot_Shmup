extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var triggered = false
var player = null
var degrees = [0, 45, 90, 135, 180, -45, -90, -135]
var velocity = Vector2()
var speed = 100
var wait_time = 2
var attack_range = 30

onready var timer = $Timer

func idle_move():
	if not triggered and timer.time_left <= 0:
		var num = randi()%8
		rotation_degrees = degrees[num]
		match num:
			0:
				velocity = Vector2(0, speed)
				timer.start(wait_time)
			1:
				velocity = Vector2(-speed/1.5, speed/1.5)
				timer.start(wait_time)
			2:
				velocity = Vector2(-speed, 0)
				timer.start(wait_time)
			3:
				velocity = Vector2(-speed/1.5, -speed/1.5)
				timer.start(wait_time)
			4:
				velocity = Vector2(0, -speed)
				timer.start(wait_time)
			5:
				velocity = Vector2(speed/1.5, speed/1.5)
				timer.start(wait_time)
			6:
				velocity = Vector2(speed, 0)
				timer.start(wait_time)
			7:
				velocity = Vector2(speed/1.5, -speed/1.5)
				timer.start(wait_time)
				
			

func on_hit(amount):
	health -= amount

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()

func _process(_delta):
	if health <= 0:
		queue_free()
	$Health_Bar._on_health_updated(health)
	if triggered:
		look_at(player.global_position)
		rotation_degrees -= 90
		var to_player = player.global_position - global_position
		var distance = to_player.length()
		var direction = to_player.normalized()
		
		if distance > attack_range:
			move_and_slide(direction * speed)
	else:
		idle_move()
		velocity = move_and_slide(velocity)
		$AnimatedSprite.play("Walking")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		triggered = true
		player = body


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		triggered = false
