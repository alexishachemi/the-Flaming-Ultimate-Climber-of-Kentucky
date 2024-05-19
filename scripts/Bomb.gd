extends Area2D

# Explosion settings
var explosion_radius = 100
var explosion_force = 10000
var delay = 1.0

var totalLife = 10.0

@onready var timer = $Timer
@onready var animSprite = $"../Explosion"

func _ready():
	animSprite.connect("animation_finished", get_parent().queue_free)
	timer.wait_time = delay
	timer.one_shot = true
	timer.connect("timeout", explode)
	# Start blinking on area entry

func _process(delta):
	totalLife -= delta
	if totalLife < 0:
		get_parent().queue_free()

func start_blinking():
	timer.start()
	update_blink()

func update_blink():
	var remaining = timer.time_left
	var frequency = max(0.1, remaining / 10)  # Minimum frequency should not be zero
	var color = Color(1, abs(sin(remaining / frequency)), abs(sin(remaining / frequency)), 1)  # Blink in red
	$BombSprite.modulate = color
	if remaining > 0:
		await get_tree().create_timer(frequency).timeout
		update_blink()

func explode():
	# Get all colliding bodies within the Area2D
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			body.hurt(20)
			var vec_to_body = body.global_position - global_position
			var distance = vec_to_body.length()
			if distance < explosion_radius and distance > 0:
				var force = vec_to_body.normalized() * (explosion_force * (1 - distance / explosion_radius))
				#body.apply_impulse(force, Vector2())
				body.velocity += force * 1000
	animSprite.visible = true
	animSprite.play("explosion")


func _on_body_entered(body):
	if body is CharacterBody2D:
		start_blinking()



func _on_AnimatedSprite_animation_finished():
	get_parent().queue_free()

