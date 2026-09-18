class_name InvItem
extends Resource

@export_category("Identity")
@export var item_name: String = ""
@export var texture: Texture2D
@export var cost: float
@export var description: String = ""

@export_category("modifiers")
@export var can_richochet: float
@export var damage_boost: float
@export var health_boost: float
@export var attack_speed_boost: float
@export var crit_chance: float
@export var movement_speed_boost: float
@export var backwards_movement: float
@export var dissipating_crit: float
@export var multishot: float
@export var sideshot: float

@export_category("ability")
@export var giant_bomb: float
@export var shield: float
