--Nodes

minetest.register_node("villages:colony_deed", {
	description = "Villager Colony Deed",
	tiles = {"villages_deed.png"},
	inventory_image = "villages_deed.png",
	wield_image = "villages_deed.png",
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	selection_box = {type="wallmounted",},
	groups = {crumbly=1, dig_immediate=3, oddly_breakable_by_hand=1},
	--on_construct = function(pos, node, placer)
		--local meta = minetest.get_meta(pos)
	--end,
	walkable = false,
})

minetest.register_node("villages:hobo_deed", {
	description = "Hobo Colony Deed",
	tiles = {"villages_hobo_deed.png"},
	inventory_image = "villages_hobo_deed.png",
	wield_image = "villages_hobo_deed.png",
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	selection_box = {type="wallmounted",},
	groups = {crumbly=1, dig_immediate=3, oddly_breakable_by_hand=1,},
	--on_construct = function(pos, node, placer)
		--local meta = minetest.get_meta(pos)
		--meta:set_string("position", "not in building")
		--meta:set_string("population", "0")
	--end,
	walkable = false,
})
--[[
minetest.register_abm({
	nodenames = {"villages:colony_deed"},
	interval = 5,
	chance = 1,
	action = function(pos, node)
		local meta = minetest:get_meta(pos)
			minetest.chat_send_all("a deed just checked for a house")
		if meta:get_string("position") == "inside building" then
			if meta:get_string("population") == "0" and math.random(1,2) == 1 then
				minetest.add_entity(pos, "mobs_npc:npc")
				meta:set_string("population", "1")
				minetest.chat_send_all("npc spawned")
			end
		end
		local beds = minetest.find_node_near(pos, 5, {"beds:bed_bottom", "beds:bed", "beds:bed_yellow_bottom", "beds:bed_brown_bottom", "beds:bed_magenta_bottom", "beds:bed_blue_bottom", "beds:bed_orange_bottom", "beds:bed_cyan_bottom", "beds:bed_pink_bottom", "beds:bed_black_bottom", "beds:bed_white_bottom", "beds:bed_darkgrey_bottom", "beds:bed_grey_bottom", "beds:bed_green_bottom", "beds:bed_purple_bottom", "beds:bed_darkgreen_bottom"})
		local light_sources = minetest.find_node_near(pos, 5, {"default:torch", "default:torch_wall", "default:torch_floor", "default:torch_ceiling", "mese_lamp"})
		local doors = minetest.find_node_near(pos, 5, {"doors:door_wood_a", "doors:door_glass_a", "doors:door_obsidian_glass_a"})
		if beds ~= nil and light_sources ~= nil and doors ~= nil then
			meta:set_string("position", "inside building")
			minetest.chat_send_all("a building was found")
		else
			meta:set_string("position", "not in building")
			minetest.chat_send_all("no building was found")
		end
	end
})
]]

--village generation

local function get_positions(pos)
	local positions = {
		{{x=pos.x+11, y=pos.y, z=pos.z+11}},
		{{x=pos.x+11, y=pos.y, z=pos.z+32}},
		{{x=pos.x+11, y=pos.y, z=pos.z+53}},
		{{x=pos.x+11, y=pos.y, z=pos.z+74}},
		{{x=pos.x-10, y=pos.y, z=pos.z+11}},
		{{x=pos.x-10, y=pos.y, z=pos.z+32}},
		{{x=pos.x-10, y=pos.y, z=pos.z+53}},
		{{x=pos.x-10, y=pos.y, z=pos.z+74}},
	}
	return positions
end

local function find_ground(pos)
	local pos2 = pos
	local pos = pos
	local node = minetest.get_node(pos).name
	if minetest.get_item_group(node, "cracky") > 0 or minetest.get_item_group(node, "crumbly") > 0 then
	return pos
	end
	for i=-10,20 do
		pos2.y = pos2.y-i
		local node = minetest.get_node(pos).name
		if minetest.get_item_group(node, "cracky") > 0 or minetest.get_item_group(node, "crumbly") > 0 then
		pos.y = pos2.y
		return pos
		end
	end
end

local village_rarity = 10

minetest.register_on_generated(function(minp, maxp)
	if maxp.y > 3000 or maxp.y < -50 then
		return
	end
	if math.random(1, village_rarity) == 1 then
	local surface = minetest.find_nodes_in_area(minp, maxp,
		{"default:dirt_with_grass", "mapgen:dirt_with_leafygrass", "mapgen:dirt_with_junglegrass", "mapgen:dirt_with_swampgrass", "default:dirt_with_dry_grass", "default:dirt_with_snow"})
	for n = 1, #surface do
		if math.random(1, village_rarity*1000) == 1 then
			local pos = {x=surface[n].x, y=surface[n].y, z=surface[n].z}
			local positions = get_positions(pos)
			for _, position in ipairs(positions) do
			local number = math.random(1,7)
			local test_pos = position[1]
			local place_pos = find_ground(test_pos)
			if place_pos == nil then 
			minetest.chat_send_all("didn't work :]")
			return end
				local node = minetest.get_node(place_pos).name
				minetest.place_schematic(place_pos, minetest.get_modpath("villages").."/schematics/structure_"..number..".mts", random, {["default:dirt_with_grass"] = node}, true)
			end
		end
		end
	end
end)