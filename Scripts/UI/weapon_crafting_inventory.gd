extends Inventory

@export var ModsPage: Control
@export var StatsPage: Control
@export var HandleHolder: Control
@export var AttachmentHolder: Control
@export var ProjectileHolder: Control
@export var ModHolder: Control
var handle: ItemUI = null
var attachment: ItemUI = null
var projectile: ItemUI = null
var mods: Array[ItemUI]
const flyweight: ItemUI = null

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## If successful: Adds weapon to player, adds weapon UI to equipment UI, destroys this weapon crafting menu
func make_weapon() -> bool:
	if handle != null && attachment != null && projectile != null:
		if ItemUI.dragging_some_item:
			ItemUI.dragging_item.dragging = false # TODO: bug when make weapon button overlaps with item, this 'if' doesn't fix
			ItemUI.dragging_some_item = false
			ItemUI.dragging_some_ui = false
		if GameManager.instance.craft_weapon(handle, attachment, projectile): # TODO: Next the weapon is added to the player's equipment inventory, in this script OR GameManager
			new_remove(handle) ## TODO: replaced remove with new_remove
			new_remove(attachment)
			new_remove(projectile) # TODO: handle if remove fails (remove by force)
			print("crafted weapon success")
			return true
	print("crafted weapon failure")
	return false

## Override
func is_valid_type(item: ItemUI):
	return super(item) && (item.data.item_type == ItemData.ATTACHMENT || item.data.item_type == ItemData.HANDLE || item.data.item_type == ItemData.PROJECTILE || item.data.item_type == ItemData.MOD)

func get_type() -> String:
	print("get type: crafting")
	return CRAFTING

func can_add(item: ItemUI) -> bool:
	print("can_add_crafting")
	return is_valid_type(item)

func can_remove(item: ItemUI) -> bool:
	print("can_remove_crafting")
	return is_instance_valid(item) && items.has(item) 

func new_add(item: ItemUI):
	print("new_add_crafting")
	items.append(item)
	item.inventory = self
	item.position = Vector2.ZERO
	match item.data.item_type:
		ItemData.ATTACHMENT:
			if attachment != null:
				var a: ItemUI = attachment
				new_remove(attachment)
				GameManager.instance.ui_man.storage.new_add(a) # TODO: rework into real code
			attachment = item
			AttachmentHolder.add_child(item)
			item.item_parent = AttachmentHolder
		ItemData.HANDLE:
			if handle != null:
				var h: ItemUI = handle
				new_remove(handle)
				GameManager.instance.ui_man.storage.new_add(h) # TODO: rework into real code
			handle = item
			HandleHolder.add_child(item)
			item.item_parent = HandleHolder
		ItemData.PROJECTILE:
			if projectile != null:
				var p: ItemUI = projectile
				new_remove(projectile)
				GameManager.instance.ui_man.storage.new_add(p) # TODO: rework into real code
			projectile = item
			ProjectileHolder.add_child(item)
			item.item_parent = ProjectileHolder
		ItemData.MOD:
			if mods.size() >= 2: # TODO: max mod size reached?
				pass
			mods.append(item)
			ModHolder.add_child(item)
			item.item_parent = ModHolder
		_:
			printerr("baddd")

func new_remove(item: ItemUI):
	print("new_remove_crafting")
	if item.get_parent():
		item.get_parent().remove_child(item)
	items.erase(item)
	match item.data.item_type:
		ItemData.ATTACHMENT:
			if attachment == item:
				attachment = null
		ItemData.HANDLE:
			if handle == item:
				handle = null
		ItemData.PROJECTILE:
			if projectile == item:
				projectile = null
		ItemData.MOD:
			pass
		_:
			print("bad bad bad this is bad bad this bad") ## uhm


## Old Implementation:
#func check_item(item: ItemUI) -> bool:
	#return super(item) && (item.data.item_type == ItemData.ATTACHMENT || item.data.item_type == ItemData.HANDLE || item.data.item_type == ItemData.PROJECTILE || item.data.item_type == ItemData.MOD)
#
#func _add_item(item: ItemUI) -> void:
	#match item.data.item_type:
		#ItemData.ATTACHMENT:
			#if attachment != null:
				#var a: ItemUI = attachment
				#remove(attachment)
				#GameManager.instance.ui_man.storage.add(a) # TODO: rework into real code
			#attachment = item
			#AttachmentHolder.add_child(item)
			#item.item_parent = AttachmentHolder
		#ItemData.HANDLE:
			#if handle != null:
				#var h: ItemUI = handle
				#remove(handle)
				#GameManager.instance.ui_man.storage.add(h) # TODO: rework into real code
			#handle = item
			#HandleHolder.add_child(item)
			#item.item_parent = HandleHolder
		#ItemData.PROJECTILE:
			#if projectile != null:
				#var p: ItemUI = projectile
				#remove(projectile)
				#GameManager.instance.ui_man.storage.add(p) # TODO: rework into real code
			#projectile = item
			#ProjectileHolder.add_child(item)
			#item.item_parent = ProjectileHolder
		#ItemData.MOD:
			#if mods.size() >= 2: # TODO: max mod size reached?
				#pass
			#mods.append(item)
			#ModHolder.add_child(item)
			#item.item_parent = ModHolder
		#_:
			#printerr("baddd")
			#return
	#items.append(item)
	#item.inventory = self
	#item.position = Vector2.ZERO
#
### Item requested to be moved away from this inventory
#func remove(item: ItemUI) -> bool:
	#if is_instance_valid(item):
		#match item.data.item_type:
			#ItemData.ATTACHMENT:
				#if attachment == item:
					#item.get_parent().remove_child(item)
					#attachment = null
					#return true
			#ItemData.HANDLE:
				#if handle == item:
					#item.get_parent().remove_child(item)
					#handle = null
					#return true
			#ItemData.PROJECTILE:
				#if projectile == item:
					#item.get_parent().remove_child(item)
					#projectile = null
					#return true
			#ItemData.MOD:
				#if items.has(item):
					#item.get_parent().remove_child(item)
					#items.erase(item)
					#return true
	#print("Remove item false for weapon_crafting, item: " + item.data.item_name)
	#return false # TODO: this reports false when this inven doesn't have the item, is that good..?

## Old Implementation:
#func check_item(item: ItemUI) -> bool:
	#return super(item) && (item.data.item_type == ItemData.ATTACHMENT || item.data.item_type == ItemData.HANDLE || item.data.item_type == ItemData.PROJECTILE || item.data.item_type == ItemData.MOD)
#
#func _add_item(item: ItemUI) -> void:
	#match item.data.item_type:
		#ItemData.ATTACHMENT:
			#if attachment != null:
				#var a: ItemUI = attachment
				#remove(attachment)
				#GameManager.instance.ui_man.storage.add(a) # TODO: rework into real code
			#attachment = item
			#AttachmentHolder.add_child(item)
			#item.item_parent = AttachmentHolder
		#ItemData.HANDLE:
			#if handle != null:
				#var h: ItemUI = handle
				#remove(handle)
				#GameManager.instance.ui_man.storage.add(h) # TODO: rework into real code
			#handle = item
			#HandleHolder.add_child(item)
			#item.item_parent = HandleHolder
		#ItemData.PROJECTILE:
			#if projectile != null:
				#var p: ItemUI = projectile
				#remove(projectile)
				#GameManager.instance.ui_man.storage.add(p) # TODO: rework into real code
			#projectile = item
			#ProjectileHolder.add_child(item)
			#item.item_parent = ProjectileHolder
		#ItemData.MOD:
			#if mods.size() >= 2: # TODO: max mod size reached?
				#pass
			#mods.append(item)
			#ModHolder.add_child(item)
			#item.item_parent = ModHolder
		#_:
			#printerr("baddd")
			#return
	#items.append(item)
	#item.inventory = self
	#item.position = Vector2.ZERO
#
### Item requested to be moved away from this inventory
#func remove(item: ItemUI) -> bool:
	#if is_instance_valid(item):
		#match item.data.item_type:
			#ItemData.ATTACHMENT:
				#if attachment == item:
					#item.get_parent().remove_child(item)
					#attachment = null
					#return true
			#ItemData.HANDLE:
				#if handle == item:
					#item.get_parent().remove_child(item)
					#handle = null
					#return true
			#ItemData.PROJECTILE:
				#if projectile == item:
					#item.get_parent().remove_child(item)
					#projectile = null
					#return true
			#ItemData.MOD:
				#if items.has(item):
					#item.get_parent().remove_child(item)
					#items.erase(item)
					#return true
	#print("Remove item false for weapon_crafting, item: " + item.data.item_name)
	#return false # TODO: this reports false when this inven doesn't have the item, is that good..?
