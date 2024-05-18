extends CharacterBody2D

@export_enum("blue", "green", "purple", "pink")
var color: String = "blue"

@export var rightHand: HAND = HAND.CLOSED
@export var leftHand: HAND = HAND.CLOSED

@export var speed: int = 10
@export var jumpForce: int = 300
@export var gravityForce: int = 1
@export var dragForce: float = 10
@export var maxVel: Vector2 = Vector2(500, 1000)
var direction: int = 1

enum HAND {OPENED, CLOSED, ROCKING, CLIMBING}
enum FACE {ANGRY, ANNOYED, CONFIDENT, DEAD, HAPPY, MALICIOUS, SCARED}
enum STATE {GROUND, AIR, J_AIR, DJ_AIR, CLIMB}
var state: STATE = STATE.GROUND

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
		HAND.CLIMBING:
			return "closed"

func move_hand(is_right: bool):
	var hand: AnimatedSprite2D = $leftHand
	var action: HAND = leftHand
	var dir = -1
	
	if is_right:
		hand = $rightHand
		action = rightHand
		dir = 1
	match action:
		HAND.OPENED:
			hand.position = Vector2(130 * dir, -70)
			hand.rotation = 0
		HAND.CLOSED:
			hand.position = Vector2(110 * dir, -10)
			hand.rotation = -80 * dir
		HAND.CLIMBING:
			hand.position = Vector2(130 * dir, -70)
			hand.rotation = 0
		HAND.ROCKING:
			hand.position = Vector2(130 * dir, -10)
			hand.rotation = 0

func set_state(new_state: STATE):
	state = new_state
	match state:
		STATE.GROUND:
			set_hand(HAND.CLOSED, false)
			set_hand(HAND.ROCKING, true)
			set_face(FACE.CONFIDENT)
		STATE.CLIMB:
			set_hands(HAND.CLIMBING)
			set_face(FACE.SCARED)
		_:
			set_hands(HAND.OPENED)
			set_face(FACE.HAPPY)

func set_hand(action: HAND, is_right: bool):
	if is_right:
		rightHand = action
		$rightHand.play(color + '_' + hand_to_string(action))
	else:
		leftHand = action
		$leftHand.play(color + '_' + hand_to_string(action))
	move_hand(is_right)

func set_hands(action: HAND):
	set_hand(action, true)
	set_hand(action, false)

func jump():
	match state:
		STATE.GROUND: set_state(STATE.J_AIR)
		STATE.AIR: set_state(STATE.J_AIR)
		STATE.J_AIR: set_state(STATE.DJ_AIR)
		_: return
	velocity.y = -jumpForce

func move():
	var drag = min(abs(velocity.x), dragForce)
	if state != STATE.GROUND and is_on_floor():
		set_state(STATE.GROUND)
	direction = 0
	if Input.is_action_pressed("move_left"):
		direction += -1
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_just_pressed("jump"):
		jump()
	if velocity.x > 0:
		drag *= -1
	if state == STATE.GROUND:
		velocity.x += drag
	velocity.x += direction * speed
	velocity.y += gravityForce
	velocity = velocity.clamp(-maxVel, maxVel)
	move_and_slide()

func _ready():
	set_color(color)
	set_state(STATE.GROUND)

func _process(delta):
	move()
