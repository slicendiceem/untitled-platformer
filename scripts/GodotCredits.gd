extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.BLUE_VIOLET

var speed_up := false
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []
var menu_scene = load("res://scene/mainMenu.tscn")

# Custom font variables
var custom_font: Font
var title_font: Font

# Font sizes and spacing
const TITLE_FONT_SIZE := 48
const NORMAL_FONT_SIZE := 32
const LINE_HEIGHT := 80
const SECTION_SPACING := 20  # Extra space between sections

# Track which line in the entire credits we're on
var global_line_index := 0

var credits = [
	["Slime'N Dungeon"],
	["Contributors"], 
	["Scripting & Level Design", "Mina Magdy", "Abdelrahman Ezzat"],
	["Scripting & UI Design", "Ahmed Hatem"],
	["Art & Animation", "Omar Eslam"],
	["Music", "Ahmed Abaza", "Karim Hesham", "Ahmed Hatem"],
	["Documentation", "Karim Hesham"],
	["Trello Management", "Osama Mohamed"]
]

func _ready():
	# Print debug info
	print("Viewport size: ", get_viewport().size)
	print("CreditsContainer position: ", $CreditsContainer.position)
	print("CreditsContainer size: ", $CreditsContainer.size)
	
	# Set black background
	set_background_black()
	
	# Load custom fonts
	load_custom_fonts()

func set_background_black():
	# Method 1: If you already have a ColorRect in your scene
	if has_node("ColorRect"):
		var background = $ColorRect
		background.color = Color.BLACK
		background.size = get_viewport().size
		print("Set existing ColorRect to black background")
	

func load_custom_fonts():
	# Try to load custom font - replace with your actual font path
	var font_path = "res://fonts/ComicNeueSansID.ttf"
	var title_font_path = "res://fonts/Metal Glass.otf"
	
	# Load custom font if it exists, otherwise use default
	if ResourceLoader.exists(font_path):
		custom_font = load(font_path)
		print("Loaded custom font from: ", font_path)
	else:
		custom_font = null
		print("Custom font not found at: ", font_path, " - using default font")
	
	# Load title font if it exists
	if ResourceLoader.exists(title_font_path):
		title_font = load(title_font_path)
		print("Loaded title font from: ", title_font_path)
	else:
		title_font = custom_font
		print("Title font not found - using regular font for titles")

func _process(delta):
	var scroll_speed = base_speed * delta
	
	# Add new sections/lines
	if section_next:
		section_timer += delta
		if speed_up:
			section_timer += delta * (speed_up_multiplier - 1)
		
		if section_timer >= section_time:
			section_timer = 0
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				# Add section spacing before new section (except first section)
				if global_line_index > 0:
					global_line_index += 1  # Add a "spacer line"
				add_line()
				print("Started new section")
	
	else:
		line_timer += delta
		if speed_up:
			line_timer += delta * (speed_up_multiplier - 1)
		
		if line_timer >= line_time:
			line_timer = 0
			add_line()
	
	# Apply speed up
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	# Scroll all lines
	for i in range(lines.size() - 1, -1, -1):
		var line = lines[i]
		line.position.y -= scroll_speed
		
		# Remove when above the screen
		if line.position.y < -100:
			line.queue_free()
			lines.remove_at(i)
			print("Removed line")
	
	# Check if finished
	if credits.size() == 0 and lines.size() == 0 and started:
		finish()

func add_line():
	if section == null or section.size() == 0:
		print("Section is empty")
		return
	
	var text = section.pop_front()
	print("Adding line (", curr_line, "): ", text, " | Global index: ", global_line_index)
	
	# Create label
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Set size
	var screen_width = get_viewport().size.x
	
	# Determine if this is a title (first line of section)
	var is_title = (curr_line == 0)
	
	# Determine line height based on position
	var line_height = LINE_HEIGHT
	
	# Titles get standard height
	if is_title:
		line_height = LINE_HEIGHT
	# Last line in section gets extra bottom spacing
	elif section.size() == 0:  # This is the last line of the section
		line_height = LINE_HEIGHT + SECTION_SPACING
	
	label.size = Vector2(screen_width, line_height)
	
	# Apply styling
	if is_title:
		label.add_theme_color_override("font_color", title_color)
		label.add_theme_font_size_override("font_size", TITLE_FONT_SIZE)
		if title_font:
			label.add_theme_font_override("font", title_font)
	else:
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_font_size_override("font_size", NORMAL_FONT_SIZE)
		if custom_font:
			label.add_theme_font_override("font", custom_font)
	
	# Calculate Y position
	# Start from bottom of screen, accumulate based on global_line_index
	var y_pos = get_viewport().size.y + (global_line_index * LINE_HEIGHT)
	label.position = Vector2(0, y_pos)
	
	# Add to scene
	$CreditsContainer.add_child(label)
	lines.append(label)
	
	# Increment global line counter
	global_line_index += 1
	
	# Set up for next line/section
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true
		curr_line = 0
		print("Section complete")

func finish():
	if not finished:
		finished = true
		print("Credits finished, returning to menu")
		get_tree().change_scene_to_packed(menu_scene)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
		print("Speed up ON")
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
		print("Speed up OFF")
