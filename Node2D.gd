extends Node2D

var rng = RandomNumberGenerator.new()
var newX = 200
var newY = 300

var mousePosition = Vector2(0,0)

# var dynamic_font = DynamicFont.new()
var dynamic_font

var colors = [Color("#ff0000"), Color("#00ff00"), Color("#0000ff"), Color("#ffffff")]
var currentColorIdx = 0

const SPEED = 40
var zumbiVelocity = Vector2(0,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	rng.randomize()	
	$ColorRect.color = colors[0]
	# dynamic_font.font_data = load("res://Lobster-Regular.ttf")
	dynamic_font = load("res://new_dynamicfont.tres")
	dynamic_font.size = 64
	$Player/Zumbi.play()
	$Sprite/AnimationPlayer.play("move")

func _draw():
	draw_string(dynamic_font, Vector2(400,100), "Dev Games!")
	draw_line(Vector2(0,0), Vector2(100,100), Color("#ff00ff00"), 2)
	# draw_circle(Vector2(100, 100), 20.0, Color(1.0,1.0,1.0))
	draw_polyline([Vector2(100, 100), Vector2(100,200), Vector2(newX,newY), Vector2(100,100)], colors[currentColorIdx])

func muda_cor():
	currentColorIdx += 1
	if currentColorIdx > colors.size() - 1:
		currentColorIdx = 0
	$ColorRect.color = colors[currentColorIdx]
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		muda_cor()
		
	mousePosition = get_viewport().get_mouse_position()
	$Sprite.position = mousePosition
	
	if Input.is_action_pressed("ui_right"):
		zumbiVelocity.x = SPEED		
		$Player/Zumbi.flip_h = false
		$Player/Zumbi.play("walk")
	elif Input.is_action_pressed("ui_left"):
		zumbiVelocity.x = -SPEED
		$Player/Zumbi.flip_h = true
		$Player/Zumbi.play("walk")
	else:
		zumbiVelocity.x = 0
		$Player/Zumbi.play("idle")
		
	$Player.move_and_slide(zumbiVelocity)
		

func _on_Timer_timeout():
	newX = rng.randi_range(150, 250)
	newY = rng.randi_range(250, 350)
	update()


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.pressed:
       muda_cor()
