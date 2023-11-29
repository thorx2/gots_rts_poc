extends Unit

class_name EnemyUnit

@export_category("Combat")
@export var detection_range : float


func _process(delta: float) -> void:

    if attack_target == null:
        for player in GameManager.player_units:
            if player == null:
                continue

            if player.global_position.distance_to(global_position) < detection_range:
                attack_target = player
                break
            pass
        pass
    else:
        if attack_target.global_position.distance_to(global_position) > detection_range:
            attack_target = null
        pass

    super._process(delta)
    pass
