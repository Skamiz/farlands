--
-- Helper functions
--

local function is_water(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "water") ~= 0
end


local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i / math.abs(i)
	end
end


local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end


local function get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end

--
-- Boat entity
--

local boat = {
	physical = true,
	-- Warning: Do not change the position of the collisionbox top surface,
	-- lowering it causes the boat to fall through the world if underwater
	collisionbox = {-0.5, -0.35, -0.5, 0.5, 0.3, 0.5},
	visual = "mesh",
	mesh = "boat.obj",
	textures = {"boat.png"},

	driver = nil,
	v = 0,
	last_v = 0,
	removed = false
}


function boat.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local name = clicker:get_player_name()
	if self.driver and clicker == self.driver then
		self.driver = nil
		clicker:set_detach()
		default.player_attached[name] = false
		default.player_set_animation(clicker, "stand" , 30)
		local pos = clicker:get_pos()
		pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
		minetest.after(0.1, function()
			clicker:set_pos(pos)
		end)
	elseif not self.driver then
		local attach = clicker:get_attach()
		if attach and attach:get_luaentity() then
			local luaentity = attach:get_luaentity()
			if luaentity.driver then
				luaentity.driver = nil
			end
			clicker:set_detach()
		end
		self.driver = clicker
		clicker:set_attach(self.object, "",
			{x = 0, y = 11, z = -3}, {x = 0, y = 0, z = 0})
		default.player_attached[name] = true
		minetest.after(0.2, function()
			default.player_set_animation(clicker, "sit" , 30)
		end)
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end


function boat.on_activate(self, staticdata, dtime_s)
	self.object:set_armor_groups({immortal = 1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
	self.last_v = self.v
end


function boat.get_staticdata(self)
	return tostring(self.v)
end


function boat.on_punch(self, puncher)
	if not puncher or not puncher:is_player() or self.removed then
		return
	end
	if self.driver and puncher == self.driver then
		self.driver = nil
		puncher:set_detach()
		default.player_attached[puncher:get_player_name()] = false
	end
	if not self.driver then
		self.removed = true
		local inv = puncher:get_inventory()
		if not minetest.settings:get_bool("creative_mode")
				or not inv:contains_item("main", "boats:boat") then
			local leftover = inv:add_item("main", "boats:boat")
			-- if no room in inventory add a replacement boat to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		-- delay remove to ensure player is detached
		minetest.after(0.1, function()
			self.object:remove()
		end)
	end
end


function boat.on_step(self, dtime)
	self.v = get_v(self.object:get_velocity()) * get_sign(self.v)
	if self.driver then
		local ctrl = self.driver:get_player_control()
		local yaw = self.object:get_yaw()
		if ctrl.up then
			self.v = self.v + 0.1
		elseif ctrl.down then
			self.v = self.v - 0.1
		end
		if ctrl.left then
			if self.v < 0 then
				self.object:set_yaw(yaw - (1 + dtime) * 0.03)
			else
				self.object:set_yaw(yaw + (1 + dtime) * 0.03)
			end
		elseif ctrl.right then
			if self.v < 0 then
				self.object:set_yaw(yaw + (1 + dtime) * 0.03)
			else
				self.object:set_yaw(yaw - (1 + dtime) * 0.03)
			end
		end
	end
	local velo = self.object:get_velocity()
	if self.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		self.object:set_pos(self.object:get_pos())
		return
	end
	local s = get_sign(self.v)
	self.v = self.v - 0.02 * s
	if s ~= get_sign(self.v) then
		self.object:set_velocity({x = 0, y = 0, z = 0})
		self.v = 0
		return
	end
	if math.abs(self.v) > 5 then
		self.v = 5 * get_sign(self.v)
	end

	local p = self.object:get_pos()
	p.y = p.y - 0.5
	local new_velo
	local new_acce = {x = 0, y = 0, z = 0}
	if not is_water(p) then
		local nodedef = minetest.registered_nodes[minetest.get_node(p).name]
		if (not nodedef) or nodedef.walkable then
			self.v = 0
			new_acce = {x = 0, y = 1, z = 0}
		else
			new_acce = {x = 0, y = -9.8, z = 0}
		end
		new_velo = get_velocity(self.v, self.object:get_yaw(),
			self.object:get_velocity().y)
		self.object:set_pos(self.object:get_pos())
	else
		p.y = p.y + 1
		if is_water(p) then
			local y = self.object:get_velocity().y
			if y >= 5 then
				y = 5
			elseif y < 0 then
				new_acce = {x = 0, y = 20, z = 0}
			else
				new_acce = {x = 0, y = 5, z = 0}
			end
			new_velo = get_velocity(self.v, self.object:get_yaw(), y)
			self.object:set_pos(self.object:get_pos())
		else
			new_acce = {x = 0, y = 0, z = 0}
			if math.abs(self.object:get_velocity().y) < 1 then
				local pos = self.object:get_pos()
				pos.y = math.floor(pos.y) + 0.5
				self.object:set_pos(pos)
				new_velo = get_velocity(self.v, self.object:get_yaw(), 0)
			else
				new_velo = get_velocity(self.v, self.object:get_yaw(),
					self.object:get_velocity().y)
				self.object:set_pos(self.object:get_pos())
			end
		end
	end
	self.object:set_velocity(new_velo)
	self.object:set_acceleration(new_acce)
end


minetest.register_entity("boats:boat", boat)


minetest.register_craftitem("boats:boat", {
	description = "Boat",
	inventory_image = "boat_item.png",
	wield_image = "boat_item.png",
	liquids_pointable = true,
	groups = {flammable = 2},

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		if not is_water(pointed_thing.under) then
			return itemstack
		end
		pointed_thing.under.y = pointed_thing.under.y + 0.5
		boat = minetest.add_entity(pointed_thing.under, "boats:boat")
		if boat then
			boat:set_yaw(placer:get_look_horizontal())
			if not minetest.settings:get_bool("creative_mode") then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
})


minetest.register_craft({
	output = "boats:boat",
	recipe = {
		{"",           "",           ""          },
		{"group:wood", "",           "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "boats:boat",
	burntime = 20,
})
