-- read/write
function hunger.read(player)
	local inv = player:get_inventory()
	if not inv then
		return nil
	end
	local hgp = inv:get_stack("hunger", 1):get_count()
	if hgp == 0 then
		hgp = 21
		inv:set_stack("hunger", 1, ItemStack({name = ":", count = hgp}))
	else
		hgp = hgp
	end
	if tonumber(hgp) > HUNGER_MAX + 1 then
		hgp = HUNGER_MAX + 1
	end
	return hgp - 1
end

function hunger.save(player)
	local inv = player:get_inventory()
	local name = player:get_player_name()
	local value = hunger[name].lvl
	if not inv or not value then
		return nil
	end
	if value > HUNGER_MAX then
		value = HUNGER_MAX
	end
	if value < 0 then
		value = 0
	end
	inv:set_stack("hunger", 1, ItemStack({name = ":", count = value + 1}))
	return true
end

function hunger.update_hunger(player, new_lvl)
	local name = player:get_player_name() or nil
	if not name then
		return false
	end
	if minetest.setting_getbool("enable_damage") == false then
		hunger[name] = 20
		return
	end
	local lvl = hunger[name].lvl
	if new_lvl then
		 lvl = new_lvl
	end
	if lvl > HUNGER_MAX then
		lvl = HUNGER_MAX
	end
	hunger[name].lvl = lvl
	if lvl > 20 then
		lvl = 20
	end
	hud.change_item(player, "hunger", {number = lvl})
	hunger.save(player)
end
local update_hunger = hunger.update_hunger

-- player-action based hunger changes
function hunger.handle_node_actions(pos, oldnode, player, ext)
	if not player or not player:is_player() then
		return
	end
	local name = player:get_player_name()
	if not name or not hunger[name] then
		return
	end
	
	local exhaus = hunger[name].exhaus
	if not exhaus then
		hunger[name].exhaus = 0
		--return
	end

	local new = HUNGER_EXHAUST_PLACE

	-- placenode event
	if not ext then
		new = HUNGER_EXHAUST_DIG
	end

	-- assume its send by action_timer(globalstep)
	if not pos and not oldnode then
		new = HUNGER_EXHAUST_MOVE
	end

	exhaus = exhaus + new

	if exhaus > HUNGER_EXHAUST_LVL then
		exhaus = 0
		local h = tonumber(hunger[name].lvl)
		if h > 0 then
			update_hunger(player, h - 1)
		end
	end

	hunger[name].exhaus = exhaus
end

function hunger.setSprinting(playerName, sprinting) --Sets the state of a player (0=stopped/moving, 1=sprinting)
	local player = minetest.get_player_by_name(playerName)
	if hunger.players[playerName] then
		hunger.players[playerName]["sprinting"] = sprinting
		if sprinting == true then
			player:set_physics_override({speed=2}) --, jump=1.5})
		elseif sprinting == false then
			player:set_physics_override({speed=1}) --, jump=1})
		end
		return true
	end
	return false
end

-- Time based hunger functions
local hunger_timer = 0
local health_timer = 0
local action_timer = 0

local function hunger_globaltimer(dtime)
	hunger_timer = hunger_timer + dtime
	health_timer = health_timer + dtime
	action_timer = action_timer + dtime

	if action_timer > HUNGER_MOVE_TICK then
		for _, player in ipairs(minetest.get_connected_players()) do
			local controls = player:get_player_control()
			-- Determine if the player is walking
			if controls.up or controls.down or controls.left or controls.right then
				hunger.handle_node_actions(nil, nil, player)
			end
		end
		action_timer = 0
	end

	-- lower saturation by 1 point after <HUNGER_TICK> second(s)
	if hunger_timer > HUNGER_TICK then
		for _, player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			local tab = hunger[name]
			if tab then
				local hunger = tab.lvl
				if hunger > 0 then
					update_hunger(player, hunger - 1)
				end
			end
		end
		hunger_timer = 0
	end

	-- heal or damage player, depending on saturation
	if health_timer > HUNGER_HEALTH_TICK then
		for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			local tab = hunger[name]
			if tab then
				--local air = player:get_breath() or 0
				local hp = player:get_hp()

				-- heal player by 1 hp if not dead and saturation is > 15 (of 30) player is not drowning
				--[[
				if tonumber(tab.lvl) < hp and hunger.players[name]["sprinting"] == false and air > 0 then
					hunger.update_hunger(player, hunger[name].lvl + 1)
				end
				--]]

				-- or damage player by 1 hp if saturation is < 2
				if tonumber(tab.lvl) < HUNGER_STARVE_LVL then
					player:set_hp(hp - HUNGER_STARVE)
				end
			end
		end
		health_timer = 0
	end

	--Get the gametime
	local gameTime = minetest.get_gametime()

	--Loop through all connected players
	for playerName, playerInfo in pairs(hunger.players) do
		local player = minetest.get_player_by_name(playerName)
		if player ~= nil then
			--Check if the player should be sprinting
			if player:get_player_control()["aux1"] and
					(player:get_player_control()["up"] or
					player:get_player_control()["down"] or
					player:get_player_control()["jump"] or
					player:get_player_control()["sneak"]) then
				hunger.players[playerName]["shouldSprint"] = true
			else
				hunger.players[playerName]["shouldSprint"] = false
			end
			
			--If the player is sprinting, create particles behind him/her 
			if playerInfo["sprinting"] == true and gameTime % 0.1 == 0 then
				local numParticles = math.random(1, 2)
				local playerPos = player:getpos()
				local playerNode = minetest.get_node({x=playerPos["x"], y=playerPos["y"]-1, z=playerPos["z"]})
				if playerNode["name"] ~= "air" then
					for i=1, numParticles, 1 do
						minetest.add_particle({
							pos = {
								x=playerPos["x"]+math.random(-1,1)*math.random()/2,
								y=playerPos["y"]+0.1,
								z=playerPos["z"]+math.random(-1,1)*math.random()/2
							},
							vel = {x=0, y=5, z=0},
							acc = {x=0, y=-13, z=0},
							expirationtime = math.random(),
							size = math.random()+0.5,
							collisiondetection = true,
							vertical = false,
							texture = "sprint_particle.png"
						})
					end
				end
			end

			--Adjust player states
			if hunger.players[playerName]["shouldSprint"] == true then --Stopped
				hunger.setSprinting(playerName, true)
			elseif hunger.players[playerName]["shouldSprint"] == false then
				hunger.setSprinting(playerName, false)
			end
			
			--Lower the player's stamina if sprinting
			if playerInfo["sprinting"] == true then 
				hunger.update_hunger(player, hunger[playerName].lvl - dtime / 4)
				if hunger[playerName].lvl < 1 then
					hunger.setSprinting(playerName, false)
				end
			
			end
		end
	end

end

if minetest.setting_getbool("enable_damage") then
	minetest.register_globalstep(hunger_globaltimer)
end


-- food functions
local food = hunger.food

function hunger.register_food(name, hunger_change, replace_with_item, poisen, heal, sound)
	food[name] = {}
	food[name].saturation = hunger_change	-- hunger points added
	food[name].replace = replace_with_item	-- what item is given back after eating
	food[name].poisen = poisen				-- time its poisening
	food[name].healing = heal				-- amount of HP
	food[name].sound = sound				-- special sound that is played when eating
end

-- Poison player
local function poisenp(tick, time, time_left, player)
	time_left = time_left + tick
	if time_left < time then
		minetest.after(tick, poisenp, tick, time, time_left, player)
	else
		hud.change_item(player, "hunger", {text = "hud_hunger_fg.png"})
	end
	local hp = player:get_hp() -1 or 0
	if hp > 0 then
		player:set_hp(hp)
	end
end

-- wrapper for minetest.item_eat (this way we make sure other mods can't break this one)
local org_eat = core.do_item_eat
core.do_item_eat = function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	local old_itemstack = itemstack
	itemstack = hunger.eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
	for _, callback in pairs(core.registered_on_item_eats) do
		local result = callback(hp_change, replace_with_item, itemstack, user, pointed_thing, old_itemstack)
		if result then
			return result
		end
	end
	return itemstack
end

function hunger.eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
	local item = itemstack:get_name()
	local def = food[item]
	if not def then
		def = {}
		def.saturation = hp_change * 1.3
		def.replace = replace_with_item
	end
	local func = hunger.item_eat(def.saturation, def.replace, def.poisen, def.healing, def.sound)
	return func(itemstack, user, pointed_thing)
end

function hunger.item_eat(hunger_change, replace_with_item, poisen, heal, sound)
    return function(itemstack, user, pointed_thing)
	if itemstack:take_item() ~= nil and user ~= nil then
		local name = user:get_player_name()
		local sat = tonumber(hunger[name].lvl)
		local hp = user:get_hp()
		-- Saturation
		if sat < HUNGER_MAX and hunger_change then
			sat = sat + hunger_change
			if hp < sat then
				user:set_hp(sat)
			end
			hunger.update_hunger(user, sat)
		end
		-- Healing
		if hp < 20 and heal then
			hp = hp + heal
			if hp > 20 then
				hp = 20
			end
			user:set_hp(hp)
		end
		-- Poison
		if poisen then
			hud.change_item(user, "hunger", {text = "hunger_statbar_poisen.png"})
			poisenp(1.0, poisen, 0, user)
		end

		-- eating sound
		if not sound then
			sound = "hunger_eat"
		end
		minetest.sound_play(sound, {to_player = name, gain = 0.7})

		if replace_with_item then
			if itemstack:is_empty() then
				itemstack:add_item(replace_with_item)
			else
				local inv = user:get_inventory()
				if inv:room_for_item("main", {name=replace_with_item}) then
					inv:add_item("main", replace_with_item)
				else
					local pos = user:getpos()
					pos.y = math.floor(pos.y + 0.5)
					core.add_item(pos, replace_with_item)
				end
			end
		end
	end

	return itemstack
    end
end
