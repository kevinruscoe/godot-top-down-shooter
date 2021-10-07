extends Node2D

const BulletScene = preload("res://Scenes/Bullet.tscn")

var accuracy: float = 1.0 setget set_accuracy, get_accuracy
var spread: Vector2 = Vector2(400, 20) setget set_spread, get_spread
var reload_duration: float = 1.0 setget set_reload_duration, get_reload_duration
var ammo: int = 10 setget set_ammo, get_ammo
var clip_size: int = 10 setget set_clip_size, get_clip_size
var projectiles_per_shot: int = 1.0 setget set_projectiles_per_shot, get_projectiles_per_shot
var projectile_speed: int = 800 setget set_projectile_speed, get_projectile_speed
var shots_per_second: float = 10.0 setget set_shots_per_second, get_shots_per_second
var kickback: float = 200.0 setget set_kickback, get_kickback

var _reload_timer: Timer
var _bullet_timer: Timer
var _should_show_target_cone: bool = true
var _target_cone: Polygon2D
var _target_cone_vectors: PoolVector2Array
onready var _player = get_parent()

func _ready():
	self._reload_timer = Timer.new()
	self._reload_timer.set_one_shot(true)
	self._reload_timer.set_wait_time(self.get_reload_duration())
	self.add_child(self._reload_timer)
	
	self._bullet_timer = Timer.new()
	self._bullet_timer.set_one_shot(true)
	self._bullet_timer.set_wait_time(self.get_shots_per_second())
	self.add_child(self._bullet_timer)

func _process(delta):
	self._draw_target_cone()
	self._track_reload_lock()

	if Input.is_action_pressed("ui_shoot"):
		self._shoot()

	look_at(get_global_mouse_position())

func _draw_target_cone():
	if self._should_show_target_cone:
		if not self._target_cone:
			self._target_cone = Polygon2D.new()
			self._target_cone.set_color(Color(1, 1, 1, .1))
			self.add_child(self._target_cone)

		self._target_cone_vectors = PoolVector2Array();

		self._target_cone_vectors.append(self.get_node("Muzzle").position)
	
		var upper_point:Vector2 = self.get_node("Muzzle").position
		upper_point.x += self.get_spread().x
		upper_point.y += self.get_spread().y
		self._target_cone_vectors.append(upper_point)
		
		var lower_point:Vector2 = self.get_node("Muzzle").position
		lower_point.x += self.get_spread().x
		lower_point.y -= self.get_spread().y
		self._target_cone_vectors.append(lower_point)

		self._target_cone_vectors.append(self.get_node("Muzzle").position)
		
		self._target_cone.set_polygon(self._target_cone_vectors)
	
func _track_reload_lock():
	if self._reload_timer.is_stopped() and self.get_ammo() == 0:
		self.set_ammo(self.get_clip_size())

func _shoot():
	# if were reloading or throttled by bullet count, bail
	if not self._reload_timer.is_stopped() or not self._bullet_timer.is_stopped():
		return

	# reload, start reload timer
	self.set_ammo(self.get_ammo() - 1)
	if self.get_ammo() <= 0:
		self._reload_timer.start(self.get_reload_duration())

	# throttle bullet count
	self._bullet_timer.start(100 / self.get_shots_per_second() / 100)

	# handle bullet spawn, and target
	var bullet_position: Vector2 = self.get_node("Muzzle").global_position
	var mouse_position: Vector2 = get_global_mouse_position()

	for projectile in self.get_projectiles_per_shot():

		# spread and accuracy effects where a bullet could hit
		# so we get the clicked positon, and tweak its position
		var angle_to_destination = rad2deg(bullet_position.angle_to_point(mouse_position)) + 180
		
		mouse_position.y = bullet_position.y + self.get_spread().x * sin(deg2rad(angle_to_destination))
		mouse_position.x = bullet_position.x + self.get_spread().x * cos(deg2rad(angle_to_destination))
		
		var bullet_velocity: Vector2 = -(bullet_position - mouse_position)

		# get accuracy, if 1.0 it'll hit 100% of the time, if .5, it'll hit 50%.
		# spread is the min and max distance from the target it could hit
		# accuracy dependant
		var spread_negator: float = self.get_spread().y - self.get_spread().y * self.get_accuracy()
		
		bullet_velocity.x = rand_range(
			bullet_velocity.x - spread_negator, 
			bullet_velocity.x + spread_negator
		)
		bullet_velocity.y = rand_range(
			bullet_velocity.y - spread_negator,
			bullet_velocity.y + spread_negator
		)
		
		bullet_velocity = bullet_velocity.normalized()

		# apply knockback
		_player.set_velocity(_player.get_velocity() + (bullet_velocity * -1) * self.get_kickback())

		var bullet = BulletScene.instance()
		self.get_node("/root").add_child(bullet)
		bullet.set_speed(self.get_projectile_speed())
		bullet.set_velocity(bullet_velocity)
		bullet.set_position(bullet_position)
		bullet.set_max_distance(self.get_spread().x)
		bullet.fire()

func set_accuracy(value):
	accuracy = value

func get_accuracy():
	return accuracy

func set_spread(value):
	spread = value
	
func get_spread():
	return spread

func set_reload_duration(value):
	reload_duration = value
	
func get_reload_duration():
	return reload_duration

func set_ammo(value):
	ammo = value
	
func get_ammo():
	return ammo

func set_clip_size(value):
	clip_size = value
	
func get_clip_size():
	return clip_size

func set_projectiles_per_shot(value):
	projectiles_per_shot = value
	
func get_projectiles_per_shot():
	return projectiles_per_shot

func set_projectile_speed(value):
	projectile_speed = value
	
func get_projectile_speed():
	return projectile_speed

func set_shots_per_second(value):
	shots_per_second = value
	
func get_shots_per_second():
	return shots_per_second

func set_kickback(value):
	kickback = value
	
func get_kickback():
	return kickback
