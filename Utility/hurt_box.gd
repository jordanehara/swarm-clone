extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(node_path, damage, angle, knockback, slow)

var hit_once_array = []

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if not area.get("damage") == null and not area.get("HurtBoxType") == null:
			match area.HurtBoxType:
				0: # Cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: # HitOnce
					if hit_once_array.has(area) == false:
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array", Callable(self, "remove_from_list")):
								area.connect("remove_from_array", Callable(self, "remove_from_list"))
					else:
						return
				2: # DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			var slow = 1.0
			var hitter = area
			if not area.get("angle") == null:
				angle = area.angle
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			if not area.get("slow") == null:
				slow = area.slow
			if not area.get("player") == null:
				hitter = area.player
			if not area.get("totaldamage") == null:
				area.totaldamage += damage
			if not area.get("healPercent") == null:
				if area.healPercent != 0:
					hitter.hp += clamp(damage * area.healPercent, 0, hitter.maxhp)
			
			emit_signal("hurt", hitter.get_path(), damage, angle, knockback, slow)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
