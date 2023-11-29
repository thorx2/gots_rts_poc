extends CharacterBody2D

class_name Unit

@export var unit_paramter : Unit_Parameters

@onready var visual: Sprite2D = $Visual
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var is_player : bool

var last_attack_time : float
var attack_target : CharacterBody2D = null
var current_health : int

func _ready() -> void:
    current_health = unit_paramter.max_health

    if is_player:
        GameManager.player_units.append(self)
    else:
        GameManager.enemy_units.append(self)
    pass

func _physics_process(delta: float) -> void:
    if navigation_agent_2d.is_navigation_finished():
        return

    var move_dir : Vector2 = global_position.direction_to(navigation_agent_2d.get_next_path_position())

    velocity = move_dir * unit_paramter.move_speed * delta

    move_and_slide()
    pass


func _process(delta: float) -> void:
    target_check()
    pass

func target_check() -> bool:
    if attack_target == null:
        return false

    var dist : float = global_position.distance_to(attack_target.global_position)

    if (dist <= unit_paramter.attack_range):
        navigation_agent_2d.target_position = global_position
        try_attack_target()
        return true
    else:
        navigation_agent_2d.target_position = attack_target.global_position

    return false

func take_damage(amount : float) -> void:
    current_health -= amount
    if current_health <= 0:
        queue_free()

    visual.modulate = Color.RED
    await get_tree().create_timer(0.1).timeout
    visual.modulate = Color.WHITE
    pass

func move_to_position(location : Vector2) -> void:
    attack_target = null
    navigation_agent_2d.target_position = location
    pass

func set_target(new_target : CharacterBody2D) -> void:
    attack_target = new_target
    pass

func try_attack_target() -> void:
    var curr_time : float = Time.get_ticks_msec()

    if curr_time - last_attack_time > (unit_paramter.attack_rate * 1000):
        last_attack_time = curr_time
        (attack_target as Unit).take_damage(unit_paramter.damage_per_hit)
        pass
    pass
