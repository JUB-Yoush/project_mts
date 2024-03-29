extends Sprite3D

func _ready() -> void:
	##Makes the node ignore its parents transformations. Node transformations are only in global space.
	set_as_toplevel(true)

func update(ray:RayCast)-> void:
	ray.force_raycast_update()
	var is_colliding:= ray.is_colliding()
	visible = is_colliding
	if is_colliding:
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		global_transform.origin = collision_point + collision_normal * 0.01
		look_at(collision_point - collision_normal,global_transform.basis.y.normalized())
