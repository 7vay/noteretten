extends Node2D 

@export var noiseHeight : NoiseTexture2D # Generator für Terrain-Noise
@export var noiseBiome : NoiseTexture2D  # Generator für Biome

var noise : Noise
var noiseB : Noise

@onready var tileMap = $TileMap  # Deine TileMap
@export var camera : Camera2D

var renderDistance = 10
var tileSize = 16
var lastPositionCamera = Vector2.ZERO

#CHUNK-SETTINGS 
var CHUNK_SIZE = 10
var loaded_chunks = {} 

#SOURCE IDS 
var sourceIdWater = 0 
var sourceIdGras = 1
var sourceIdSand = 2
var sourceIdMagic = 3
var sourceIdIce = 4
var sourceIdHills = 5

#ATLAS
var hillsTreppeAtlas = Vector2i(9,4)
var waterAtlas = Vector2i(0,0)
var grasAtlas = Vector2i(1,1)

#LAYER
var waterLayer = 0
var sandLayer = 1
var grasLayer = 2
var magicLayer = 3
var iceLayer = 4
var hillsLayer = 5

#TERRAIN-IDs
var terrainGrasInt = 0
var terrainSandInt = 1
var terrainMagicInt = 2
var terrainIceInt = 3
var terrainHillsInt = 4
var terrainNumbers = 5

#CHANCES
enum Biome {GRAS, ICE, MAGIC, SAND}
var biomeData = {
	Biome.ICE: {"tree": 0.006, "stone": 0.009, "bush": 0.01, "ore": 0.005, "snow": 0.03},
	Biome.GRAS: {"tree": 0.05, "stone": 0.05, "bush": 0.04, "plants": 0.4},
	Biome.MAGIC: {"tree": 0.01, "stone": 0.02, "bush": 0.01, "plants": 0.01, "ore": 0.01},
	Biome.SAND: {"tree": 0.01, "stone": 0.02, "plants": 0.02}
}

func _ready():
	noise = noiseHeight.noise
	noiseB = noiseBiome.noise
	update_world()

func update_world():
	var cameraPosition = camera.global_position
	var viewportSize = Vector2(get_viewport().size) / camera.zoom  
	
	var min_x = int((cameraPosition.x - viewportSize.x / 2) / tileSize) - renderDistance
	var max_x = int((cameraPosition.x + viewportSize.x / 2) / tileSize) + renderDistance
	var min_y = int((cameraPosition.y - viewportSize.y / 2) / tileSize) - renderDistance
	var max_y = int((cameraPosition.y + viewportSize.y / 2) / tileSize) + renderDistance
	
	var min_chunk_x = int(floor(min_x / CHUNK_SIZE))
	var max_chunk_x = int(floor(max_x / CHUNK_SIZE))
	var min_chunk_y = int(floor(min_y / CHUNK_SIZE))
	var max_chunk_y = int(floor(max_y / CHUNK_SIZE))
	
	for cx in range(min_chunk_x, max_chunk_x + 1):
		for cy in range(min_chunk_y, max_chunk_y + 1):
			var chunk_key = str(cx) + "_" + str(cy)
			if not loaded_chunks.has(chunk_key):
				if load_chunk(cx, cy) == false:
					generate_chunk(cx, cy)

func generate_chunk(chunk_x: int, chunk_y: int) -> void:
	var chunk_key = str(chunk_x) + "_" + str(chunk_y)
	var chunk_data = {
		"gras": [],
		"sand": [],
		"ice": [],
		"magic": [],
		"hills": [],
		"trees": [],
		"stones": [],
	}
	
	for local_x in range(0, CHUNK_SIZE):
		for local_y in range(0, CHUNK_SIZE):
			var world_x = chunk_x * CHUNK_SIZE + local_x
			var world_y = chunk_y * CHUNK_SIZE + local_y
			var pos = Vector2i(world_x, world_y)
			var biome
			var BiomeProp
			
			
			var noise_val : float = noise.get_noise_2d(world_x, world_y)
			var noise_val_Biome : float = noiseB.get_noise_2d(world_x, world_y)
			print(noise_val_Biome)
			var newTerrain = -1
			var newTerrainGras = -1
			var newTerrainSand = -1
			
			#if noise_val >= 0.4:
				#newTerrain = terrainHillsInt
			
			newTerrainSand = terrainSandInt
			biome = "sand"
			if noise_val_Biome >= -0.3:
				if noise_val_Biome >= 0.25:
					newTerrain = terrainMagicInt
					biome = "magic"
				newTerrainGras = terrainGrasInt
				biome = "gras"
			elif noise_val_Biome <= -0.4:
				newTerrain = terrainIceInt
				biome = "ice"
					
			
			tileMap.set_cell(waterLayer, pos, sourceIdWater, waterAtlas)
			
			if newTerrain != -1 or newTerrainGras != -1 or newTerrainSand != -1:
				if newTerrainGras != -1:
					chunk_data["gras"].append(pos)
					if biome == "gras":
						BiomeProp = biomeData[Biome.GRAS]
						if randf() < BiomeProp["plants"]:
							spawnPlants(pos, biome)
						elif randf() < BiomeProp["tree"]:
							spawnTree(pos, biome)
						elif randf() < BiomeProp["bush"]:
							spawnBush(pos, biome)
						elif randf() < BiomeProp["stone"]:
							spawnStone(pos, biome)
				if newTerrainSand != -1:
					chunk_data["sand"].append(pos)
					if biome == "sand":
						BiomeProp = biomeData[Biome.SAND]
						if randf() < BiomeProp["stone"]:
							spawnStone(pos, biome)
						elif randf() < BiomeProp["tree"]:
							spawnTree(pos, biome)
						elif randf() < BiomeProp["plants"]:
							spawnPlants(pos, biome)
				if newTerrain == terrainHillsInt:
					chunk_data["hills"].append(pos)
				elif newTerrain == terrainMagicInt:
					chunk_data["magic"].append(pos)
					BiomeProp = biomeData[Biome.MAGIC]
					if randf() < BiomeProp["plants"]:
						spawnPlants(pos, biome)
					elif randf() < BiomeProp["stone"]:
						spawnStone(pos, biome)
					elif randf() < BiomeProp["tree"]:
						spawnTree(pos, biome)
					elif randf() < BiomeProp["bush"]:
						spawnBush(pos, biome)
					elif randf() < BiomeProp["ore"]:
						spawnOre(pos, biome)
				elif newTerrain == terrainIceInt:
					BiomeProp = biomeData[Biome.ICE]
					chunk_data["ice"].append(pos)
					if randf() < BiomeProp["stone"]:
						spawnStone(pos, biome)
					elif randf() < BiomeProp["tree"]:
						spawnTree(pos, biome)
					elif randf() < BiomeProp["ore"]:
						spawnOre(pos, biome)
					elif randf() < BiomeProp["snow"]:
						spawnSnow(pos, biome)
					elif randf() < BiomeProp["bush"]:
						spawnBush(pos, biome)
					
					
	tileMap.set_cells_terrain_connect(grasLayer, chunk_data["gras"], terrainGrasInt, 0)
	tileMap.set_cells_terrain_connect(sandLayer, chunk_data["sand"], terrainSandInt, 0)
	#tileMap.set_cells_terrain_connect(hillsLayer, chunk_data["hills"], terrainHillsInt, 0)
	tileMap.set_cells_terrain_connect(magicLayer, chunk_data["magic"], terrainMagicInt, 0)
	tileMap.set_cells_terrain_connect(iceLayer, chunk_data["ice"], terrainIceInt, 0)
	
	loaded_chunks[chunk_key] = chunk_data
	
	save_chunk(chunk_x, chunk_y)

func save_chunk(chunk_x: int, chunk_y: int) -> void:
	var chunk_key = str(chunk_x) + "_" + str(chunk_y)
	if not loaded_chunks.has(chunk_key):
		return
	var chunk_data = loaded_chunks[chunk_key]
	
	var file_path = "res://saved/chunks/" + chunk_key + ".json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(chunk_data))
		file.close()


func load_chunk(chunk_x: int, chunk_y: int) -> bool:
	var chunk_key = str(chunk_x) + "_" + str(chunk_y)
	var file_path = "user://chunk_" + chunk_key + ".json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file.file_exists(file_path):
		return false
	if file:
		return false
	var data_str = file.get_as_text()
	file.close()
	var json = JSON.new()
	var chunk_data = json.parse(data_str)
	
	tileMap.set_cells_terrain_connect(grasLayer, chunk_data["grass"], terrainGrasInt, 0)
	tileMap.set_cells_terrain_connect(sandLayer, chunk_data["sand"], terrainSandInt, 0)
	tileMap.set_cells_terrain_connect(hillsLayer, chunk_data["hills"], terrainHillsInt, 0)
	tileMap.set_cells_terrain_connect(magicLayer, chunk_data["magic"], terrainMagicInt, 0)
	tileMap.set_cells_terrain_connect(iceLayer, chunk_data["ice"], terrainIceInt, 0)
	
	loaded_chunks[chunk_key] = chunk_data
	return true
	
func spawnStone(pos, biome):
	var stone
	var x = randf()
	if biome == "ice":
		stone = preload("res://Items/Rescources/IceBiome/stoneIce.tscn").instantiate()
	elif biome == "gras":
		if x > 0.5:
			stone = preload("res://Items/Rescources/GrasBiome/stone.tscn").instantiate()
		else:
			stone = preload("res://Items/Rescources/GrasBiome/stoneSmal.tscn").instantiate()
	elif biome == "magic":
		if x > 0.5:
			stone = preload("res://Items/Rescources/MagicBiome/stone.tscn").instantiate()
		else:
			stone = preload("res://Items/Rescources/MagicBiome/stoneSmal.tscn").instantiate()
	elif biome == "sand": 
		if x > 0.5:
			stone = preload("res://Items/Rescources/SandBiome/stone.tscn").instantiate()
		else:
			stone = preload("res://Items/Rescources/SandBiome/stoneSmal.tscn").instantiate()
	stone.position = pos * tileSize
	add_child(stone)
	
func spawnTree(pos, biome):
	var x = randf()
	var tree
	if biome == "ice":
		if x > 0.5:
			tree = preload("res://Items/Rescources/IceBiome/treeIce.tscn").instantiate()
		else: 
			tree = preload("res://Items/Rescources/IceBiome/treeSide.tscn").instantiate()
	elif biome == "gras":
		if x > 0.75:
			tree = preload("res://Items/Rescources/GrasBiome/tree.tscn").instantiate()
		elif x > 0.5:
			tree = preload("res://Items/Rescources/GrasBiome/bigtree.tscn").instantiate()
		elif x > 0.25:
			tree = preload("res://Items/Rescources/GrasBiome/log.tscn").instantiate()
		elif x > 0.15:
			tree = preload("res://Items/Rescources/GrasBiome/BerryTree.tscn").instantiate()
		else:
			tree = preload("res://Items/Rescources/GrasBiome/treeSide.tscn").instantiate()
	elif biome == "magic":
		if x > 0.75:
			tree = preload("res://Items/Rescources/MagicBiome/BerryTree.tscn").instantiate()
		elif x > 0.5:
			tree = preload("res://Items/Rescources/MagicBiome/bush.tscn").instantiate()
		elif x > 0.25:
			tree = preload("res://Items/Rescources/MagicBiome/log.tscn").instantiate()
		elif x > 0.15:
			tree = preload("res://Items/Rescources/MagicBiome/tree.tscn").instantiate()
		else:
			tree = preload("res://Items/Rescources/MagicBiome/treeSide.tscn").instantiate()
	elif biome == "sand": 
		if x > 0.5:
			tree = preload("res://Items/Rescources/SandBiome/tree.tscn").instantiate()
		else: 
			tree = preload("res://Items/Rescources/SandBiome/BigTree.tscn").instantiate()
	tree.position = pos * tileSize
	add_child(tree)
	
func spawnOre(pos, biome):
	var ore
	if biome == "ice":
		ore = preload("res://Items/Rescources/IceBiome/Ore.tscn").instantiate()
	elif biome == "magic":
		ore = preload("res://Items/Rescources/MagicBiome/ore.tscn").instantiate()
	ore.position = pos * tileSize
	add_child(ore)
	
func spawnBush(pos, biome):
	var bush
	if biome == "ice":
		bush = preload("res://Items/Rescources/IceBiome/bush.tscn").instantiate()
	elif biome == "gras":
		bush = preload("res://Items/Rescources/GrasBiome/bush.tscn").instantiate()
	elif biome == "magic":
		bush = preload("res://Items/Rescources/MagicBiome/bush.tscn").instantiate()
	bush.position = pos * tileSize
	add_child(bush)
	
func spawnSnow(pos, biome):
	var snow = preload("res://Items/Rescources/IceBiome/snow.tscn").instantiate()
	snow.position = pos * tileSize
	add_child(snow)
	
func spawnPlants(pos, biome):
	var x = randf()
	var p
	if biome == "gras":
		if x > 0.6: #Flower
			if x > 0.85:
				p = preload("res://Items/Rescources/GrasBiome/flower.tscn").instantiate()
			elif x > 0.75:
				p = preload("res://Items/Rescources/GrasBiome/flowerBlue.tscn").instantiate()
			else:
				p = preload("res://Items/Rescources/GrasBiome/flowerPink.tscn").instantiate()
		elif x > 0.3: #Leaf
			if x > 0.45:
				p = preload("res://Items/Rescources/GrasBiome/leaf.tscn").instantiate()
			else:
				p = preload("res://Items/Rescources/GrasBiome/leaf.tscn").instantiate()
		else:
			if x > 0.15:
				p = preload("res://Items/Rescources/GrasBiome/mushroom.tscn").instantiate()
			else:
				p = preload("res://Items/Rescources/GrasBiome/twoMushroom.tscn").instantiate()
				
	if biome == "sand":
		if x > 0.5:
			p = preload("res://Items/Rescources/SandBiome/kaktus.tscn").instantiate()
		else:
			p = preload("res://Items/Rescources/SandBiome/kaktusFlower.tscn").instantiate()
	if biome == "magic":
		if x > 075:
			p = preload("res://Items/Rescources/GrasBiome/flower.tscn").instantiate()
		elif x > 0.5:
			p = preload("res://Items/Rescources/GrasBiome/flowerBlue.tscn").instantiate()
		elif x > 0.25:
			p = preload("res://Items/Rescources/GrasBiome/MushroomPurp.tscn").instantiate()
		else: 
			p = preload("res://Items/Rescources/GrasBiome/twoMushroomPurp.tscn").instantiate()
		
	p.position = pos * tileSize
	add_child(p)
	
func _physics_process(_delta):
	var cameraPosition = camera.global_position
	if cameraPosition.distance_to(lastPositionCamera) > tileSize:
		update_world()
		lastPositionCamera = cameraPosition
