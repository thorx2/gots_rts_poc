extends Node2D

var selected_unit : CharacterBody2D
var player_units : Array[CharacterBody2D]
var enemy_units : Array[CharacterBody2D]


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("mouse_left_hit"):
        try_select_unit()
        pass
    elif  event.is_action_pressed("mouse_right_hit"):
        try_unit_command()
        pass
    pass

func get_selected_unit() -> CharacterBody2D:
    var space : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
    var query : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new();
    query.position = get_global_mouse_position()
    var intersection : Array[Dictionary] = space.intersect_point(query, 1)

    if !intersection.is_empty():
        return intersection[0].collider

    return null

func try_select_unit() -> void:
    var unit : CharacterBody2D = get_selected_unit()

    if unit != null && unit is Unit:
        if (unit as Unit).is_player:
            select_unit(unit)
        else:
            unselect_unit()
        pass
    pass


func select_unit(unit : CharacterBody2D) ->  void:
    unselect_unit()
    selected_unit = unit
    (selected_unit as PlayerUnit).toggle_selection_visual(true)
    pass

func unselect_unit() -> void:
    if selected_unit != null:
        (selected_unit as PlayerUnit).toggle_selection_visual(false)

    selected_unit = null
    pass

func try_unit_command() -> void:

    if selected_unit == null:
        return

    var target : CharacterBody2D = get_selected_unit()

    if target != null && target is Unit:
        if !(target as Unit).is_player:
            (selected_unit as PlayerUnit).set_target(target)
        pass
    else:
        (selected_unit as PlayerUnit).move_to_position(get_global_mouse_position())
        pass
    pass
