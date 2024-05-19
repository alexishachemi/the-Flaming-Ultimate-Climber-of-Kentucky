extends Area2D

@export_category("effect")
@export_enum("none", "cook", "eat", "keep")
var animation: String = "none"
@export var apply_before_animation: bool = false
@export var duration_sec: float = 3.0
@export var increment: bool = true
@export_category("stats")
@export var currentHealthEnabled: bool = false
@export var currentHealth: float = 0
@export var currentStaminaEnabled: bool = false
@export var currentStamina: float = 0
@export var currentJumpsEnabled: bool = false
@export var currentJumps: float = 0
@export var maxHealthEnabled: bool = false
@export var maxHealth: float = 0
@export var speedEnabled: bool = false
@export var speed: float = 0
@export var accelerationEnabled: bool = false
@export var acceleration: float = 0
@export var jumpForceEnabled: bool = false
@export var jumpForce: float = 0
@export var airJumpsEnabled: bool = false
@export var airJumps: int = 0
@export var maxStaminaEnabled: bool = false
@export var maxStamina: float = 0
@export var staminaDrainEnabled: bool = false
@export var staminaDrain: float = 0
@export var fly: bool = false

const no_delete_anims = ["keep"]
var player: Node2D = null
var animating: bool = false

func stats_to_dict():
	var stats: Dictionary = {}
	var isFlying = 0
	if fly:
		isFlying = 1
	if currentHealthEnabled:
		stats["currentHealth"] = currentHealth
	if currentStaminaEnabled:
		stats["currentStamina"] = currentStamina
	if currentJumpsEnabled:
		stats["currentJumps"] = currentJumps
	if maxHealthEnabled:
		stats["maxHealth"] = maxHealth
	if speedEnabled:
		stats["speed"] = speed
	if acceleration:
		stats["acceleration"] = acceleration
	if jumpForceEnabled:
		stats["jumpForce"] = jumpForce
	if airJumpsEnabled:
		stats["airJumps"] = airJumps
	if maxStaminaEnabled:
		stats["maxStamina"] = maxStamina
	if staminaDrainEnabled:
		stats["staminaDrain"] = staminaDrain
	stats["isFlying"] = isFlying
	return stats

func _ready():
	$InitialSprite.show()
	$CoockedSprite.hide()

func _process(_delta):
	if animating and player != null:
		global_position = player.global_position

func animate():
	$AnimationPlayer.play(animation)
	animating = true

func _on_area_entered(area):
	set_deferred("monitoring", false)
	player = area.get_parent()
	if animation != "none":
		if apply_before_animation && player.get("power_up"):
			player.power_up(stats_to_dict(), duration_sec, increment)
		if animation in no_delete_anims:
			$Timer.start(duration_sec)
		animate()
	else:
		queue_free()

func _on_animation_player_animation_finished(_anim_name):
	if not apply_before_animation and player.get("power_up"):
		player.power_up(stats_to_dict(), duration_sec, increment)
	if not animation in no_delete_anims:
		queue_free()

func _on_timer_timeout():
	queue_free()
