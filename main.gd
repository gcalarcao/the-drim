extends Node2D

@onready var click_count: Button = $UpperControl/ClickCount
@onready var start_auto_click: Button = $UpperControl/StartAutoClick
@onready var upgrade_auto_click: Button = $UpperControl/UpgradeAutoClick
@onready var upgrade_click: Button = $UpperControl/UpgradeClick
@onready var click_label: RichTextLabel = $UpperControl/ClickLabel
@onready var progress_bar: ProgressBar = $UpperControl/ProgressBar
@onready var timer: Timer = $UpperControl/Timer

var clickCount: int = 0
var clickValue: int = 1
var autoClickValue: int = 1
var autoClickUpgradeCost: int = 5
var clickUpgradeCost: int = 20

func _ready() -> void:
	progress_bar.visible = false
	start_auto_click.visible = false
	upgrade_auto_click.visible = false
	upgrade_click.visible = false
	progress_bar.max_value = timer.wait_time
	progress_bar.min_value = 0

func _process(_delta: float) -> void:
	click_label.text = "[font_size=45]" + "Coins: %d" % [clickCount]
	progress_bar.value = timer.wait_time - timer.time_left
	if clickCount >= 5:
		progress_bar.visible = true
		start_auto_click.visible = true
		upgrade_auto_click.visible = true
		upgrade_click.visible = true
		
	if clickCount >= autoClickUpgradeCost:
		upgrade_auto_click.disabled = false
	else:
		upgrade_auto_click.disabled = true
		
	if clickCount >= clickUpgradeCost:
		upgrade_click.disabled = false
	else:
		upgrade_click.disabled = true

func _on_click_count_pressed() -> void:
	clickCount += clickValue

func _on_timer_timeout() -> void:
	clickCount += autoClickValue
	progress_bar.value = 0

func _on_start_auto_click_pressed() -> void:
	print_debug("auto click")
	if timer.is_stopped():
		print_debug("auto click - timer paused")
		start_auto_click.text = "Stop auto click"
		timer.start()
	else:
		print_debug("auto click - timer not paused")
		start_auto_click.text = "Start auto click"
		timer.stop()

func _on_upgrade_auto_click_pressed() -> void:
	if clickCount >= autoClickUpgradeCost:
		clickCount -= autoClickUpgradeCost
		autoClickUpgradeCost *= 2
		upgrade_auto_click.text = "Upgrade auto click [%d Coins]" % [autoClickUpgradeCost]
		autoClickValue += 1

func _on_upgrade_click_pressed() -> void:
	if clickCount >= clickUpgradeCost:
		clickCount -= clickUpgradeCost
		clickUpgradeCost *= 2
		upgrade_click.text = "Upgrade click [%d Coins]" % [clickUpgradeCost]
		clickValue += 1
