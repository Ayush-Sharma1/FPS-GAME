extends CharacterBody3D

@export var fire_rate = float()
@onready var nav_agent = $NavigationAgent3D
@onready var target = $"../CharacterBody3D/Neck"
var hp = 100 
var SPEED = 18
var ammo = 25
var can_shoot = true
var reload = 1
var TURN_SPEED = 8
var damage = 12
var player_detected = false
var enemy_move_to_player = true
func _process(delta):
	var distance = nav_agent.distance_to_target()
	
	if hp <= 0:
		queue_free()

	if distance <= 10:
		enemy_move_to_player = false
		$face.look_at(target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad($face.rotation.y * TURN_SPEED))
		attack_player()
	else:
		enemy_move_to_player  = true
		enemy_move()
		
func attack_player():
	if can_shoot:
		can_shoot = false
		if ammo > 1:
			if $face/Node3D/AnimationPlayer != null:
				$face/Node3D/AnimationPlayer.stop(true)
				$face/Node3D/AnimationPlayer.play("Shoot")
			ammo -= 1
			await get_tree().create_timer(fire_rate).timeout
			var enemy_accuracy = randf()
			if enemy_accuracy <= 0.9:
				if $RayCast3D.get_collider() != null and $RayCast3D.get_collider().is_in_group("player"):
					$RayCast3D.get_collider().health -= damage
					can_shoot = true
					
				else: 
					can_shoot = true
				
			else: 
				can_shoot = true
		else:
			if $face/Node3D/AnimationPlayer != null:
				$face/Node3D/AnimationPlayer.stop(true)
				$face/Node3D/AnimationPlayer.play("reload")
			ammo = 25
			await get_tree().create_timer(reload).timeout
			can_shoot = true
			
	
func enemy_move():

	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED

	nav_agent.set_velocity(new_velocity)

		
func update_location(target_location):
	nav_agent.set_target_position(target_location)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.99)
	if enemy_move_to_player:
		move_and_slide()
