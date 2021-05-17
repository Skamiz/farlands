
local S = mobs.intllib

mobs.travelling_merchant = {
	items = {
		--{item for sale, price, chance of appearing in trader's inventory}
		{"default:apple 10", "default:gold_ingot 2", 10},
		{"farming:bread 10", "default:gold_ingot 4", 5},
		{"default:clay 10", "default:gold_ingot 2", 12},
		{"default:brick 10", "default:gold_ingot 4", 17},
		{"default:glass 10", "default:gold_ingot 4", 17},
		{"default:obsidian 10", "default:gold_ingot 15", 50},
		{"default:diamond 1", "default:gold_ingot 5", 40},
		{"farming:wheat 10", "default:gold_ingot 2", 17},
		{"default:tree 5", "default:gold_ingot 4", 20},
		{"default:stone 10", "default:gold_ingot 8", 17},
		{"default:desert_stone 10", "default:gold_ingot 8", 27},
		{"default:sapling 1", "default:gold_ingot 1", 7},
		{"default:pick_steel 1", "default:gold_ingot 2", 7},
		{"default:sword_steel 1", "default:gold_ingot 2", 17},
		{"default:shovel_steel 1", "default:gold_ingot 1", 17},
	},
	names = {
		"James", "John", "Bill", "Tom", "David", "Ian", "Thomas", "Steven", "Eric", "Jack", "Frank", "Peter", "Adam", "	Carl", "Joe", "Bruce", "Philip", "Steve"
	}
}

mobs.human = {
	items = {
		--{item for sale, price, chance of appearing in trader's inventory}
		{"default:apple 10", "default:gold_ingot 2", 10},
		{"farming:bread 10", "default:gold_ingot 4", 5},
		{"default:clay 10", "default:gold_ingot 2", 12},
		{"default:brick 10", "default:gold_ingot 4", 17},
		{"default:glass 10", "default:gold_ingot 4", 17},
		{"default:obsidian 10", "default:gold_ingot 15", 50},
		{"default:diamond 1", "default:gold_ingot 5", 40},
		{"farming:wheat 10", "default:gold_ingot 2", 17},
		{"default:tree 5", "default:gold_ingot 4", 20},
		{"default:stone 10", "default:gold_ingot 8", 17},
		{"default:desert_stone 10", "default:gold_ingot 8", 27},
		{"default:sapling 1", "default:gold_ingot 1", 7},
		{"default:pick_steel 1", "default:gold_ingot 2", 7},
		{"default:sword_steel 1", "default:gold_ingot 2", 17},
		{"default:shovel_steel 1", "default:gold_ingot 1", 17},
	},
	names = {
		"James", "John", "Bill", "Tom", "David", "Ian", "Thomas", "Steven", "Eric", "Jack", "Frank", "Peter", "Adam", "	Carl", "Joe", "Bruce", "Philip", "Steve"
	}
}

mobs:register_mob("mobs_npc:travelling_merchant", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	pathfinding = false,
	hp_min = 20,
	hp_max = 25,
	armor = 100,
	collisionbox = {-0.5,0,-0.5, 0.5,2.2,0.5},
	visual = "mesh",
	mesh = "travelling_merchant.b3d",
	textures = {
		{"mobs_travelling_merchant.png"},
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 1.3,
	run_velocity = 2,
	jump = 1,
	drops = {},
	water_damage = 2,
	lava_damage = 4,
	light_damage = 0,
	follow = {"default:diamond"},
	view_range = 15,
	owner = "",
	order = "stand",
	fear_height = 3,
	animation = {
		speed_normal = 15,
		speed_run = 20,
		stand_start = 1,
		stand_end = 30,
		walk_start = 35,
		walk_end = 55,
		run_start = 35,
		run_end = 55,
		punch_start = 35,
		punch_end = 55,
	},
	on_rightclick = function(self, clicker)
		mobs_trader(self, clicker, entity, mobs.travelling_merchant)
	end,
})

mobs:register_egg("mobs_npc:travelling_merchant", S("Travelling Merchant"), "default_chest_front.png", 1)

mobs:spawn({
	name = "mobs_npc:travelling_merchant",
	nodes = {"default:dirt_with_grass"},
	min_light = 7,
	chance = 80000,
	min_height = 0,
})

-- Trader ( same as NPC but with right-click shop )

mobs:register_mob("mobs_npc:trader", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	pathfinding = false,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "character.b3d",
	textures = {
		{"mobs_trader.png"}, -- by Frerin
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 2,
	run_velocity = 3,
	jump = false,
	drops = {},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	follow = {"default:diamond"},
	view_range = 15,
	owner = "",
	order = "stand",
	fear_height = 3,
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219,
	},
	on_rightclick = function(self, clicker)
		mobs_trader(self, clicker, entity, mobs.human)
	end,
})

--This code comes almost exclusively from the trader and inventory of mobf, by Sapier.
--The copyright notice below is from mobf:
-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
--
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice.
-- And of course you are NOT allow to pretend you have written it.
--
--! @file inventory.lua
--! @brief component containing mob inventory related functions
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-02
--
--! @defgroup Inventory Inventory subcomponent
--! @brief Component handling mob inventory
--! @ingroup framework_int
--! @{
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

function mobs.allow_move(inv, from_list, from_index, to_list, to_index, count, player)

	-- local from = inv:get_stack(from_list, from_index)
	-- local to = inv:get_stack(to_list, to_index)
	-- print("Transaction start------------")
	-- print(from_list, from:get_name(), from:get_count())
	-- print(to_list, to:get_name(), to:get_count())
	-- print("Count is: " .. count)

	if to_list == "selection" and from_list == "goods" or
			to_list == "goods" and from_list == "selection" or
			to_list == "goods" and from_list == "goods" then

		-- forbid moving split stacks
		local old_stack = inv:get_stack(from_list, from_index)
		if count == old_stack:get_count() then
			return count
		end
	end

	return 0
end

function mobs.allow_put(inv, listname, index, stack, player)
	if listname == "payment" then
		return stack:get_count()
	end

	return 0
end

function mobs.allow_take(inv, listname, index, stack, player)

	if listname == "payment" or (listname == "takeaway" and
			stack:get_count() == inv:get_stack(listname, index):get_count()) then
		return stack:get_count()
	else
		return 0
	end
end

mobs.trader_inventories = {}

function mobs.add_goods(entity, race)

	local goods_to_add = nil

	for i = 1, 15 do

		if math.random(0, 100) > race.items[i][3] then
			mobs.trader_inventory:set_stack("goods", i, race.items[i][1])
		end
	end
end

local function update_inventry(inv, race)
	-- print("Updating inventory.")
	-- print("Selection contains: ", inv:get_stack("selection", 1):to_string())
	local selection = inv:get_stack("selection", 1)
	if selection:is_empty() then
		inv:set_stack("price", 1, nil)
		inv:set_stack("takeaway", 1, nil)
	else
		local price = nil
		local selction_string = selection:get_name() .. " " .. selection:get_count()

		for i = 1, #race.items do
			if race.items[i][1] == selction_string then
				price = ItemStack(race.items[i][2])
			end
		end
		inv:set_stack("price", 1, price)

		local payment = inv:get_stack("payment", 1)
		if payment:get_name() == price:get_name() and
				payment:get_count() >= price:get_count() then
			inv:set_stack("takeaway", 1, selection)
		else
			inv:set_stack("takeaway", 1, nil)
		end
	end
end

function mobs_trader(self, clicker, entity, race)

	local player = clicker:get_player_name()

	if not self.id then
		self.id = (math.random(1, 1000) * math.random(1, 10000))
			.. self.name .. (math.random(1, 1000) ^ 2)
	end

	if not self.game_name then

		self.game_name = tostring(race.names[math.random(1, #race.names)])
		self.nametag = S("Trader @1", self.game_name)

		self.object:set_properties({
			nametag = self.nametag,
			nametag_color = "#00FF00"
		})

	end

	local unique_entity_id = self.id
	local is_inventory = minetest.get_inventory({
		type = "detached", name = unique_entity_id})

	local move_put_take = {

		allow_move = mobs.allow_move,
		allow_put = mobs.allow_put,
		allow_take = mobs.allow_take,

		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			update_inventry(inv, race)
		end,
		on_put = function(inv, listname, index, stack, player)
			update_inventry(inv, race)
		end,
		on_take = function(inv, listname, index, stack, player)
			if listname == "takeaway" then
				inv:set_stack("selection", 1, nil)
				local payment = inv:get_stack("payment", 1)
				payment:take_item(inv:get_stack("price", 1):get_count())
				inv:set_stack("payment", 1, payment)
			end
			update_inventry(inv, race)
		end,
	}

	if is_inventory == nil then

		mobs.trader_inventory = minetest.create_detached_inventory(unique_entity_id, move_put_take)
		mobs.trader_inventory.set_size(mobs.trader_inventory,"goods", 15)
		mobs.trader_inventory.set_size(mobs.trader_inventory,"takeaway", 1)
		mobs.trader_inventory.set_size(mobs.trader_inventory,"selection", 1)
		mobs.trader_inventory.set_size(mobs.trader_inventory,"price", 1)
		mobs.trader_inventory.set_size(mobs.trader_inventory,"payment", 1)
		mobs.add_goods(entity, race)
	end

	minetest.chat_send_player(player, S("[NPC] <Trader @1 > Hello, @2, have a look at my wares.",
		self.game_name, player))

	minetest.show_formspec(player, "trade", "size[8,10;]"
		.. default.gui_bg_img
		.. default.gui_slots
		.. "label[0,0;" .. S("Trader @1's stock:", self.game_name) .. "]"
		.. "list[detached:" .. unique_entity_id .. ";goods;.5,.5;3,5;]"
		.. "label[4.5,0.5;" .. S("Selection") .. "]"
		.. "list[detached:" .. unique_entity_id .. ";selection;4.5,1;5.5,2;]"
		.. "label[6,0.5;" .. S("Price") .. "]"
		.. "list[detached:" .. unique_entity_id .. ";price;6,1;7,2;]"
		.. "label[4.5,3.5;" .. S("Payment") .. "]"
		.. "list[detached:" .. unique_entity_id .. ";payment;4.5,4;5.5,5;]"
		.. "label[6,3.5;" .. S("Bought items") .. "]"
		.. "list[detached:" .. unique_entity_id .. ";takeaway;6,4;7.5,5.5;]"
		.. "list[current_player;main;0,6;8,4;]"
	)
end

mobs:register_egg("mobs_npc:trader", S("Trader"), "default_sandstone.png", 1)

-- compatibility
mobs:alias_mob("mobs:trader", "mobs_npc:trader")
