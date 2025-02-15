class_name Character extends CharacterBody2D


signal DirectionChanged(new_direction: Vector2)

var face_direction: Vector2 = Vector2.DOWN
var move_direction: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $PlayerSprite/AnimationPlayer
@onready var sprite: Sprite2D = $PlayerSprite
@onready var state_machine: StateMachine = $StateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()


func update_face_direction() -> bool:
	var new_direction: Vector2
	if state_machine.current_state.has_method("get_face_direction"):
		new_direction = state_machine.current_state.get_face_direction()
	else:
		new_direction = get_face_direction()
	
	if new_direction == face_direction:
		return false # No change in direction
	
	face_direction = new_direction
	
	if face_direction == Vector2.LEFT:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	DirectionChanged.emit(face_direction)
	return true


func get_face_direction() -> Vector2:
	if move_direction == Vector2.ZERO:
		return face_direction  # No movement
	
	if move_direction.y == 0:  # Horizontal movement
		return Vector2.LEFT if move_direction.x < 0 else Vector2.RIGHT
	else:  # Vertical movement
		return Vector2.UP if move_direction.y < 0 else Vector2.DOWN


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + get_animation_direction())
	pass


func get_animation_direction() -> String:
	match face_direction:
		Vector2.DOWN:
			return "down"
		Vector2.UP:
			return "up"
		_:
			return "side"
