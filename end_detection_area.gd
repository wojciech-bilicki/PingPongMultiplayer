extends Area2D

signal point_scored

func _on_body_entered(body):
	if body is Ball:
		if name == "LeftEdge" && multiplayer.get_unique_id() == 1:
			point_scored.emit()
		elif name == "RightEdge" && multiplayer.get_unique_id() != 1:
			point_scored.emit()
