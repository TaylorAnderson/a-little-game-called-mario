extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 150
const MAXFALLSPEED = 1000
const MAXSPEED = 300
const JUMPFORCE = 1500
const ACCEL = 50

# using this for jump height variability
var gravityMultiplier = 1; 

var motion = Vector2()

# grabbing the sprite child node
onready var sprite = $Sprite


func _physics_process(delta):
	motion.y += GRAVITY * gravityMultiplier;

	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	if Input.is_action_pressed("right"):
		sprite.play("run")
		# flipping the character so he's pointing the right direction
		sprite.flip_h = false;
		motion.x += ACCEL
	elif Input.is_action_pressed("left"):
		# check the Frames property in the Sprite to see the animations for this character
		sprite.play("run");
		# flipping the character so he's pointing the right direction
		sprite.flip_h = true;
		motion.x -= ACCEL
	else:
		sprite.play("idle");
		# slow down the character
		motion.x = lerp(motion.x, 0, 0.2)

	if is_on_floor():
		# resetting gravity multiplier for when we jump again
		gravityMultiplier = 1;
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
			$JumpSFX.play()
	else: 
		if Input.is_action_pressed("jump"):
			# if we hold jump, we will experience less gravity.
			# this means we will jump higher as long as we hold the button down.
			gravityMultiplier = 0.5;
		else: 
			# if the player releases the jump button, we put gravity back to what it was 
			# so the player falls at a normal speed.
			gravityMultiplier = 1;
		sprite.play("jump");

	motion = move_and_slide(motion, UP)
