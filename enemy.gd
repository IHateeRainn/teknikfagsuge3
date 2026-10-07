extends RigidBody2D
@onready var player_skib = get_tree().get_first_node_in_group("player")
@onready var navigation_agent: NavigationAgent2D = $navigation/NavigationAgent2D
@onready var level_1 = get_tree().get_first_node_in_group("level")

var explosion_scene = preload("res://Projectiles/animated_sprite_2d.tscn")
var cannonball_scene = preload("res://Projectiles/enemy_cannonball.tscn")
var gasoline_scene = preload("res://gasoline.tscn")
var hitmarker_scene = preload("res://Projectiles/hitmarker.tscn")

var health = 100
var shoot_range = 200
var speed = 50
var rSpeed = 1
var drag = -0.4
var cannonball_speed = 150
var reload_speed = 1
var reloading = false
var direction = Vector2.UP
var angle_to_player
var desired_rotation
var distance = Vector2.ZERO
var damage = 10

var fire_stacks = 0
var fire_damage = 5
var fire_duration = 2
var fire_tick_speed = 0.3
var between_fire_tick = false

func shoot():
	if !reloading:
		var cannonball = cannonball_scene.instantiate()
		cannonball.global_position = position
		cannonball.damage = damage
		get_tree().current_scene.add_child(cannonball)
		cannonball.rotation = rotation+deg_to_rad(90)
		cannonball.linear_velocity = Vector2.UP.rotated(cannonball.rotation)*cannonball_speed+linear_velocity
		reloading = true
		await get_tree().create_timer(reload_speed).timeout
		reloading = false

func _physics_process(delta: float) -> void:
	if fire_stacks > 0:
		when_on_fire()
	
	var forward = Vector2.UP.rotated(rotation)
	distance = player_skib.global_position - global_position
	
	#find næste node
	direction = navigation_agent.get_next_path_position() - global_position
	#hvis vinkel mellem spiller og enemy er lav, og inden for skyde rækkevide, opdater ønsket path, og skyd.
	if distance.length() <= shoot_range and abs(direction.angle_to(distance)) < 0.2:
		direction = player_skib.position - position
		angle_to_player = forward.angle_to(direction)
		desired_rotation = angle_to_player-PI/2
		if desired_rotation > 0:
			angular_velocity = rSpeed 
		elif desired_rotation <= 0:
			angular_velocity = -rSpeed
		shoot()
	#hvis vinkel er stor, vend mod spiller
	else:
		if forward.angle_to(direction) > 0:
			angular_velocity = rSpeed 
		elif forward.angle_to(direction) <= 0:
			angular_velocity = -rSpeed
		if forward.angle_to(direction) < abs(PI/4):
			apply_central_force(forward*speed)
	#hvis ude fra skyde rækkevide, bevæg mod path
	if distance.length() >= shoot_range:
		if forward.angle_to(direction) > 0:
			angular_velocity = rSpeed 
		elif forward.angle_to(direction) <= 0:
			angular_velocity = -rSpeed
		if forward.angle_to(direction) < abs(PI/4):
			apply_central_force(forward*speed)
	
	#drag
	apply_central_force(linear_velocity*drag)
	#check om blivet skudt
	for body in get_colliding_bodies():
		if body.is_in_group("cannonball"):
			health -= body.damage
			health_changed(body.damage)

func _ready() -> void:
	add_to_group("enemy")
	contact_monitor = true
	max_contacts_reported = 10

func when_on_fire():
	if !between_fire_tick:
		var damage_per_tick = fire_damage * fire_stacks
		health -= damage_per_tick
		health_changed(damage_per_tick)
		between_fire_tick = true
		await get_tree().create_timer(fire_tick_speed).timeout
		between_fire_tick = false

func health_changed(damage):
	var hitmarker = hitmarker_scene.instantiate()
	hitmarker.get_node("Label").text = str(damage)
	hitmarker.global_position = global_position
	get_tree().current_scene.add_child(hitmarker)
	
	if health <= 0:
		if player_skib.gasoline_item > 0:
			gasoline_explosion()
			print("GAS")
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.scale = Vector2(1,1)
		get_tree().current_scene.add_child(explosion)
		self.queue_free()

func gasoline_explosion():
	var gasoline = gasoline_scene.instantiate()
	gasoline.global_position = global_position
	get_tree().current_scene.add_child(gasoline)

#opdater path
func _on_timer_timeout() -> void:
	navigation_agent.target_position = player_skib.global_position
	pass # Replace with function body.

func add_fire_stack():
	fire_stacks += 1
	await get_tree().create_timer(fire_duration).timeout
	if is_inside_tree() and fire_stacks > 0:
		fire_stacks -= 1
