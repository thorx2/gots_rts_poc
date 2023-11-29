extends Unit

class_name PlayerUnit

@onready var select_visual: Sprite2D = $SelectVisual

func toggle_selection_visual(toggle : bool) -> void:
    select_visual.visible = toggle
    pass
