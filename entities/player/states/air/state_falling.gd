class_name StateFalling
extends StateAir

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_FALL)

func exit() -> void:
	pass

func update(delta: float) -> void:
	super.update(delta)
