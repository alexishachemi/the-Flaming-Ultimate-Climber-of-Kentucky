extends CharacterBody2D



@export_group("Apearance")
@export_enum("blue", "green", "purple", "pink")
var color: String = "blue"
@export var rightHand: HAND = HAND.CLOSED
@export var leftHand: HAND = HAND.CLOSED

@export_group("Physics")
@export var gravityForce: int = 1
@export var dragForce: float = 100
@export var maxVel: Vector2 = Vector2(500, 1000)
@export var maxGrabDist: float = 100

@export_group("Stats")
@export var speed: int = 10
@export var jumpForce: int = 300
@export var airJumps: int = 1
@export var stamina: float = 100
@export var staminaDrain: float = 5

var currentJumps = airJumps
var currentStamina = stamina

var direction: int = 1
const HAND_MAX_ROTATION: float = 60
var handRotation: float = 0

var out: bool = false
enum HAND {OPENED, CLOSED, ROCKING}
enum FACE {ANGRY, ANNOYED, CONFIDENT, DEAD, HAPPY, MALICIOUS, SCARED}
enum STATE {GROUND, AIR, J_AIR, DJ_AIR, GRAB, BLAZE}
var state: STATE = STATE.GROUND

var grabbing: bool = true
var rightHandGrabbing: bool = false
var grabZone: Area2D = null
var grabPoint: Vector2
var mouseGrabPoint: Vector2
var grabJumped:bool = false

var onBeat: bool = false

func set_color(new_color: String):
	color = new_color
	$body.play(color)
	set_hand(rightHand, true)
	set_hand(leftHand, false)

func set_face(face: FACE):
	match face:
		FACE.ANGRY:
			$face.play("angry")
		FACE.ANNOYED:
			$face.play("annoyed")
		FACE.CONFIDENT:
			$face.play("confident")
		FACE.DEAD:
			$face.play("dead")
		FACE.HAPPY:
			$face.play("happy")
		FACE.MALICIOUS:
			$face.play("malicious")
		FACE.SCARED:
			$face.play("scared")

func hand_to_string(action: HAND):
	match action:
		HAND.OPENED:
			return "open"
		HAND.CLOSED:
			return "closed"
		HAND.ROCKING:
			return "rock"

func can_grab():
	return grabZone != null

func _on_beat_pulsed(anim_name):
	onBeat = false
	set_state(state)

func beat():
	onBeat = true
	set_face(FACE.CONFIDENT)
	if not (state == STATE.GRAB and rightHandGrabbing):
		$rightHand/beatPulse.play("beat")
		set_hand(HAND.ROCKING, true)
	if not (state == STATE.GRAB and not rightHandGrabbing):
		$leftHand/beatPulse.play("beat")
		set_hand(HAND.ROCKING, false)

func grab():
	grabbing = Input.is_action_pressed("grab")
	if not grabbing or grabJumped:
		if state == STATE.GRAB:
			set_state(STATE.AIR)
		return
	if can_grab() and state != STATE.GRAB:
		set_state(STATE.GRAB)
		set_hand(HAND.CLOSED, rightHandGrabbing)
		mouseGrabPoint = get_global_mouse_position()
		if rightHandGrabbing:
			grabPoint = $rightHand/sprite.global_position
		else:
			grabPoint = $leftHand/sprite.global_position
	elif state != STATE.GRAB:
		return
	var mouse_dist_y = mouseGrabPoint.y - get_global_mouse_position().y
	var pos_y = grabPoint.y + mouse_dist_y
	pos_y = clamp(pos_y, grabPoint.y - maxGrabDist, grabPoint.y + maxGrabDist)
	velocity.y = -(global_position.y - pos_y)
	if global_position.y + velocity.y > pos_y:
		velocity.y = 0
	if global_position.y + velocity.y < -pos_y:
		velocity.y = 0
	if rightHandGrabbing:
		$rightHand.look_at(grabPoint)
	else:
		$leftHand.look_at(grabPoint)
		$leftHand.rotate(deg_to_rad(180))

func move_hands():
	var mouse_pos = get_global_mouse_position()
	var global_diff = mouse_pos - global_position

	if global_diff.x < 0:
		mouse_pos.x += abs(global_diff.x) * 2
	if state != STATE.GRAB or not rightHandGrabbing:
		$rightHand.look_at(mouse_pos)
		handRotation = clamp($rightHand.rotation_degrees, -HAND_MAX_ROTATION, HAND_MAX_ROTATION)
		$rightHand.rotation_degrees = handRotation
	if state != STATE.GRAB or rightHandGrabbing:
		$leftHand.look_at(mouse_pos)
		handRotation = clamp($leftHand.rotation_degrees, -HAND_MAX_ROTATION, HAND_MAX_ROTATION)
		$leftHand.rotation_degrees = -handRotation
	if can_grab() and state != STATE.GRAB:
		set_hand(HAND.OPENED, rightHandGrabbing)
	grab()

func set_state(new_state: STATE):
	state = new_state
	match state:
		STATE.GRAB:
			set_face(FACE.SCARED)
		_:
			set_face(FACE.HAPPY)
			set_hands(HAND.CLOSED)

func set_hand(action: HAND, is_right: bool):
	$leftHand.show()
	$rightHand.show()
	if is_right:
		rightHand = action
		$rightHand/sprite.play(hand_to_string(action))
	else:
		leftHand = action
		$leftHand/sprite.play(hand_to_string(action))

func set_hands(action: HAND):
	set_hand(action, true)
	set_hand(action, false)

func jump():
	match state:
		STATE.GROUND: set_state(STATE.J_AIR)
		STATE.AIR: set_state(STATE.J_AIR)
		STATE.J_AIR: set_state(STATE.DJ_AIR)
		STATE.GRAB:
			grabJumped = true
			set_state(STATE.J_AIR)
		_: return
	velocity.y = -jumpForce

func move_body():
	var drag = 0.0

	if Input.is_action_just_released("grab"):
		grabJumped = false
	if Input.is_action_just_pressed("jump"):
		jump()
	if state == STATE.GRAB:
		velocity = Vector2.ZERO
		return
	if state != STATE.GROUND and is_on_floor():
		set_state(STATE.GROUND)
	direction = 0
	if Input.is_action_pressed("move_left"):
		direction += -1
	if Input.is_action_pressed("move_right"):
		direction += 1
	drag = min(abs(velocity.x), dragForce)
	if velocity.x > 0:
		drag *= -1
	if is_on_floor() and direction == 0:
		velocity.x += drag
	velocity.x += direction * speed
	velocity.y += gravityForce
	velocity = velocity.clamp(-maxVel, maxVel)

func _on_BeatMover_beat(beats_passed):
	if beats_passed % 2 == 0:
		beat()

func _ready():
	var beatMover = get_parent().find_child("BeatMover")
	if beatMover != null:
		beatMover.connect("beat", _on_BeatMover_beat)
	set_color(color)
	set_state(STATE.GROUND)
	var notifier = VisibleOnScreenEnabler2D.new()
	add_child(notifier)
	notifier.connect("screen_exited", _on_ScreenExited)

func _on_ScreenExited():
	out = true
	
	set_state(STATE.AIR)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		beat()
	move_body()
	move_hands()
	move_and_slide()

func _on_right_grab_box_entered(area):
	if state == STATE.GRAB:
		return
	grabZone = area
	rightHandGrabbing = true

func _on_left_grab_box_entered(area):
	if state == STATE.GRAB:
		return
	grabZone = area
	rightHandGrabbing = false

func _on_left_grab_box_exited(area):
	if grabZone == area:
		grabZone = null
	set_hand(HAND.CLOSED, false)

func _on_right_grab_box_exited(area):
	if grabZone == area:
		grabZone = null
	set_hand(HAND.CLOSED, true)
 
