--sethome = {}

local homes_file = minetest.get_worldpath() .. "/homes"
local homepos = {}
dcb.globalhomepos = {}

local function loadhomes()
    local input = io.open(homes_file, "r")
    if input then
                repeat
            local x = input:read("*n")
            if x == nil then
                break
            end
            local y = input:read("*n")
            local z = input:read("*n")
            local name = input:read("*l")
            homepos[name:sub(2)] = {x = x, y = y, z = z}
        until input:read(0) == nil
        io.close(input)
    else
        homepos = {}
    end
    dcb.globalhomepos = homepos
end

loadhomes()

minetest.register_privilege("home", "Can use /sethome and /home")

local changed = false

minetest.register_chatcommand("home", {
    description = "Teleport you to your home point or name if teleport priv",
    params = "[name]",
    privs = {home=true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player == nil then
            -- just a check to prevent the server crashing
            return false
        end

	if param ~= "" and minetest.check_player_privs(name, {teleport=true}) then
	    --print("true")
	    if homepos[param] then
		player:setpos(homepos[param])
		minetest.chat_send_player(name, "Teleported to "..param.."'s home.")
	        return
	    else
		minetest.chat_send_player(name, param.." has no home.")
		return
	    end
	else
            if homepos[player:get_player_name()] then
	        player:setpos(homepos[player:get_player_name()])
	        minetest.chat_send_player(name, "Teleported to home!")
		return
	    else
	        minetest.chat_send_player(name, "Set a home using /sethome")
		return
	    end
	end
    end,
})

dcb.sethome = function(player)
	local name = player:get_player_name()
	local pos = player:getpos()
	homepos[player:get_player_name()] = pos
	minetest.chat_send_player(name, "Home set!")
	changed = true
	if changed then
		local output = io.open(homes_file, "w")
	    for i, v in pairs(homepos) do
		output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
	    end
	    io.close(output)
	    changed = false
	end
end

minetest.register_chatcommand("sethome", {
    description = "Set your home point",
    privs = {home=true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local pos = player:getpos()
        homepos[player:get_player_name()] = pos
        minetest.chat_send_player(name, "Home set!")
        changed = true
        if changed then
                local output = io.open(homes_file, "w")
            for i, v in pairs(homepos) do
                output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
            end
            io.close(output)
            changed = false
        end
    end,
})

dcb.get_formspec = function(player)
	local formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"button_exit[0.25,0.6;1.5,3;home;Home]"..
		"button_exit[0.25,1.6;1.5,3;spawn;Spawn]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;craft;2,0.5;3,3;]"..
		"list[current_player;craftpreview;6,1.5;1,1;]"..
		"image[5,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
		"listring[current_player;main]"..
		"listring[current_player;craft]"..
		default.get_hotbar_bg(0,4.25)
	if minetest.setting_getbool("enable_experimental") then
		formspec = formspec.."size[8,5.5]"..
		"button_exit[0.25,-0.4;1.5,3;pm;PM]"..
		"list[current_player;modifiers;7,0;1,1;]"
		if player:get_inventory():contains_item("modifiers", {name="dcb:backpack"}) then
			formspec = formspec.."list[current_player;backpack;0,5.5;8,3;]"
		end
	else
		formspec = formspec..
		"list[current_player;main;0,5.5;8,3;8]"
	end
	return formspec
end

minetest.register_on_joinplayer(function(player)
	player:set_inventory_formspec(dcb.get_formspec(player))
end)

-------------- BEGIN PM

if minetest.setting_getbool("enable_experimental") then
	print("experimental PM block")
	local pm_fs_string = {[1]="", [2]="", [3]="", [4]="", [5]=""}

	local player_index = 1 -- selected player on the left
	local pm_index = 1 -- selected pm on the right

	local revPlayers = {}

	local chatlist = {}
	local chatlist_string = "" -- the player list formspec string filled from chatlist

	local update_chatlist = function() --add or remove
		local players = minetest.get_connected_players()
		chatlist = {}
		local itr = ""
		for i,v in ipairs(players) do
			local n = v:get_player_name()
			itr = itr..n..","
			table.insert(chatlist, n)
		end
		chatlist_string = string.sub(itr, 0, -2)
		revPlayers = {}
		for i, v in pairs(chatlist) do
			revPlayers[i] = v
			--table.insert(revPlayers, {i})
		end
		print(dump(revPlayers))
	end


	local msg = "" -- the sent message string from fields.text

	local pmtable = {}
	local function insertpm(from, to, pm)
		table.insert(pmtable[to][from], "<"..from.."> "..pm)
		table.insert(pm_fs_string[from], "<"..from.."> "..pm)
	end

	--[[
	local function extractpm(name)
		pm_fs_string = pmtable["james"]["kupo"][1]..","..pmtable["james"]["kupo"][2]
	end
	--]]

	local function pmform(player, index) --player index
		--update_chatlist()
		local formspec = "size[8,8.5]"..
			default.gui_bg..
			default.gui_bg_img..
			default.gui_slots..
			"textlist[0,0;1.9,7.75;playeridx;"..chatlist_string..";"..player_index.."]"..
			"textlist[2,0;5.85,7.75;pmidx;"..pm_fs_string[index]..";1]"..
			"field[0.28,8.05;5.35,1.4;text;;]"..
			"button[5.2,7.9;1.5,1;send;Send]"..
			"button[6.57,7.9;1.5,1;openpm;Open]"
		minetest.show_formspec(player, "sethome:pm", formspec)
	end

	local function openpm(player, pm)
		local book_formspec = "size[8,8.5]"..default.gui_bg..
			"label[0.5,0.5;from "..pm.sender.."]"..
			"textarea[0.5,1.5;7.5,7;;"..minetest.formspec_escape(pm.msg)..";]"
		minetest.show_formspec(player, "sethome:pm", book_formspec)
	end
end

----------------- END PM

minetest.register_on_player_receive_fields(function(player, formname, fields)
	--if formname ~= whatever form i'm using here.
	if fields.home then
		if homepos[player:get_player_name()] then
		    player:setpos(homepos[player:get_player_name()])
		    minetest.chat_send_player(player:get_player_name(), "Teleported to home!")
		else
			local name = player:get_player_name()
			local pos = player:getpos()
			homepos[name] = pos
			minetest.chat_send_player(name, "Home set!  Use /sethome to set a new one.")
			changed = true
			if changed then
				local output = io.open(homes_file, "w")
			    for i, v in pairs(homepos) do
				output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
			    end
			    io.close(output)
			    changed = false
			end
		end
        end
	if fields.spawn then
		local spawnpos = minetest.setting_get_pos("static_spawnpoint")
		if not spawnpos then return end
		player:setpos(spawnpos)
		minetest.chat_send_player(player:get_player_name(), "Teleported to spawn!")
	end
	-- PM BEGIN
	if minetest.setting_getbool("enable_experimental") then
		if fields.pm then
			update_chatlist()
			pmform(player:get_player_name(), player_index)
		end

		if fields.playeridx then
			player_index = minetest.explode_textlist_event(fields.playeridx)["index"]
			pmform(player:get_player_name(), player_index)
		end
		if fields.pmidx then
			pm_index = minetest.explode_textlist_event(fields.pmidx)["index"]
			pmform(player:get_player_name(), player_index)
		end
		if fields.text then
			msg = fields.text
		end
		if fields.send then
			local playername = chatlist[player_index]
			minetest.log("action", "PM from "..player:get_player_name().." to "..playername..": "..msg)
			minetest.chat_send_player(playername, "PM from "..player:get_player_name()..": "..msg)
			minetest.chat_send_player(player:get_player_name(), "Message sent.")
			insertpm(player:get_player_name(), playername, msg)

			--pm_fs_string[1] = pm_fs_string[1]..minetest.formspec_escape("<"..player:get_player_name().."> "..msg)..","

			pmform(player:get_player_name(), player_index)
		end
		if fields.openpm then
			local p = player:get_player_name()
			--fill_chatlist()
			--[[
			local player_messages = pmtable["james"]
			local sender = player_messages["kupo"]
			local pmsg = sender[1]
			pm = {sender, pmsg}
			openpm(player:get_player_name(), pm)
			--]]
		end
	end
	-- END PM
end)