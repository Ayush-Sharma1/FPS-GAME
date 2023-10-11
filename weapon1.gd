extends Node3D

#gun settings
@export var damage = int()

@export var ammo = int()
@export var max_ammo = int()
@export var spare_ammo = int()

@export var ammo_per_shot = int()
@export var inf_spare_ammo = bool()

@export var full_auto = bool()

@export var reload_time = float()
@export var firerate = float()

@export var rayCast : NodePath
@onready var raycast = get_node(rayCast)
@export var bullethole = preload("res://bullet_holes.tscn")
@onready var gunshot = $gunshot_audio
@onready var rifle_reload = $reload_sound

var can_shoot = true
var reloading = false
var paused = false


func _ready():
	randomize()

func _process(_delta):
	if ammo <= 0:
		can_shoot = false
	if Input.is_action_just_pressed("reload") and reloading == false and paused == false:
		reload()
		
	if Input.is_action_pressed("inspect") and reloading == false:
		inspect()
		
	if Input.is_action_pressed("fire") and can_shoot and full_auto and paused == false:
		fire()
		
	elif Input.is_action_just_pressed("fire") and can_shoot and full_auto == false and paused == false:
		fire()
	
	#ammo counters
	$"../../../Control/Ammo".text = str(ammo)
	$"../../../Control/Spare".text = str(spare_ammo)
#shoot gun if called
func fire():
	can_shoot = false
	ammo -= ammo_per_shot
	if raycast.get_collider() != null and raycast.get_collider().is_in_group("enemies"):
		raycast.get_collider().hp -= damage
	else:
		bullet_hole()
	if  $AnimationPlayer != null:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("Arms_Fire")
		gunshot.play()
	await get_tree().create_timer(firerate).timeout
	if reloading == false:
		can_shoot = true
		
func bullet_hole():
	var collision_point = $"../gunray".get_collision_point()
	var bullet = bullethole.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_transform.origin = collision_point
	if $"../gunray".get_collision_normal() == Vector3(0, 1, 0):
		bullet.look_at($"../gunray".get_collision_point() + $"../gunray".get_collision_normal(), Vector3.RIGHT)
	elif $"../gunray".get_collision_normal() == Vector3(0, -1, 0):
		bullet.look_at($"../gunray".get_collision_point() + $"../gunray".get_collision_normal(), Vector3.RIGHT)
	else: 
		bullet.look_at($"../gunray".get_collision_point() + $"../gunray".get_collision_normal()) 
		
#reload gun if called
func reload():
	if spare_ammo > 0:
		can_shoot = false
		reloading = true
		if $AnimationPlayer != null:
			$AnimationPlayer.stop(true)
			$AnimationPlayer.play("Arms_fullreload")
			rifle_reload.play()
		await get_tree().create_timer(reload_time).timeout
		if inf_spare_ammo == false:
			var tmp_ammo
			if spare_ammo < max_ammo:
				tmp_ammo = ammo + spare_ammo
				if max_ammo - tmp_ammo >= 0:
					ammo += spare_ammo
					spare_ammo = 0
				else:
					ammo += spare_ammo
					ammo += max_ammo - tmp_ammo
					spare_ammo = -(max_ammo - tmp_ammo)
					
			else:
				spare_ammo -= max_ammo - ammo
				ammo = max_ammo
		else:
			ammo = max_ammo
		if ammo > 0:
			can_shoot = true
			reloading = false
		if ammo > 30:
			reloading = false
			can_shoot = true
			$AnimationPlayer.play("Arms_fullreload")
			rifle_reload.play()
		else: 
			reloading = false
			can_shoot = true
			
		
		
func inspect():
	reloading = false
	$AnimationPlayer.play("Arms_Inspect")
