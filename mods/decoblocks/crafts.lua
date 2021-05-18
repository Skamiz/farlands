
minetest.register_craft({
	output = 'decoblocks:anvil',
	recipe = {
		{'', 'default:steelblock', ''},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'decoblocks:bamboo_fence',
	recipe = {
		{'mapgen:bamboo', 'mapgen:bamboo', 'mapgen:bamboo'},
		{'mapgen:bamboo', 'mapgen:bamboo', 'mapgen:bamboo'},
	}
})

-- TODO: uncrafting
minetest.register_craft({
	output = 'decoblocks:bone_pillar',
	recipe = {
		{'witchcraft:bone', 'witchcraft:bone'},
		{'witchcraft:bone', 'witchcraft:bone'},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = 'decoblocks:broken_glass',
	recipe = {
		'decoblocks:framed_glass',
		'vessels:glass_fragments',
		'default:stick',
	}
})

minetest.register_craft({
	output = 'decoblocks:framed_glass',
	recipe = {
		{'', 'default:stick', ''},
		{'default:stick', 'default:glass', 'default:stick'},
		{'', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'decoblocks:pillar2_base 2',
	recipe = {
		{'', 'default:stone', ''},
		{'default:stone', 'default:stone', 'default:stone'},
	}
})

minetest.register_craft({
	output = 'decoblocks:pillar2',
	recipe = {
		{'default:stone'},
		{'default:stone'},
	}
})

minetest.register_craft({
	output = 'decoblocks:plank_walkway 12',
	recipe = {
		{'group:wood', '', 'group:wood'},
		{'group:wood', '', 'group:wood'},
		{'group:wood', '', 'group:wood'},
	}
})

minetest.register_craft({
	output = 'decoblocks:spikes 3',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', '', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'decoblocks:old_stone_tiles 4',
	recipe = {
		{'default:stone_block', 'default:stone_block'},
		{'default:stone_block', 'default:stone_block'},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = 'decoblocks:crumblestone 2',
	recipe = {
		'decoblocks:old_stone_tiles',
		"default:cobble",
		'decoblocks:old_stone_tiles',
	}
})

minetest.register_craft({
	type = "shapeless",
	output = 'decoblocks:old_stone_tiles_with_dirt 2',
	recipe = {
		'decoblocks:old_stone_tiles',
		"default:dirt",
		'decoblocks:old_stone_tiles',
	}
})

minetest.register_craft({
	type = "shapeless",
	output = 'decoblocks:stucco 8',
	recipe = {
		'mapgen:limestone',
		'mapgen:limestone',
		'mapgen:limestone',
		'mapgen:limestone',
		"group:water_bucket",
		'group:sand',
		'group:sand',
		'group:sand',
		'group:sand',
	}
})
minetest.register_craft({
	type = "shapeless",
	output = 'decoblocks:rusty_steel_plating 4',
	recipe = {
		'default:steelblock',
		"group:water_bucket",
	}
})

minetest.register_craft({
	output = 'decoblocks:vase',
	recipe = {
		{'default:clay_brick', '', 'default:clay_brick'},
		{'default:clay_brick', '', 'default:clay_brick'},
		{'', 'default:clay_brick', ''},
	}
})

minetest.register_craft({
	output = 'decoblocks:scarecrow',
	recipe = {
		{'', 'farming:pumpkin', ''},
		{'default:stick', 'farming:straw', 'default:stick'},
		{'', 'group:wood', ''},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = 'decoblocks:lantern',
	recipe = {
		'default:torch',
		'default:steel_ingot',
	}
})

minetest.register_craft({
	output = 'decoblocks:paper_lantern',
	recipe = {
		{'group:wood', 'default:paper', 'group:wood'},
		{'default:paper', 'default:torch', 'default:paper'},
		{'group:wood', 'default:paper', 'group:wood'},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "decoblocks:refined_granite",
	recipe = "mapgen:granite",
	cooktime = 5,
})

minetest.register_craft({
	type = "cooking",
	output = "decoblocks:refined_granite_brown",
	recipe = "mapgen:granite_brown",
	cooktime = 5,
})

minetest.register_craft({
	output = 'decoblocks:gold_brick',
	recipe = {
		{'default:gold_ingot', 'default:gold_ingot'},
		{'default:gold_ingot', 'default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'decoblocks:snow_bricks 4',
	recipe = {
		{'default:snowblock', 'default:snowblock'},
		{'default:snowblock', 'default:snowblock'},
	}
})
