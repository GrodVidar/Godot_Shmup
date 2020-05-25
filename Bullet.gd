extends KinematicBody2D


var speed = 500
var velocity = Vector2()
var damage = 0

func start(pos, dir, recoil, dmg):
	rotation = dir
	position = pos
	velocity = Vector2(speed, speed).rotated(rotation - rand_range(36.9 - recoil, 37.0 + recoil))
	damage = dmg

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("on_hit"):
			collision.collider.on_hit(damage)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
