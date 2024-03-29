minetest.register_alias("dcb:dcb", "dcb:pick_admin")
minetest.register_alias("dcb:tool", "dcb:pick_admin")
minetest.register_tool("dcb:pick_admin", {
	description = "Admin Pickaxe",
	inventory_image = "default_tool_woodpick.png^default_obsidian_shard.png^[colorize:black:63",
	range = 11,
	groups = {not_in_creative_inventory=1},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 3,
		groupcaps = {
			unbreakable =   {times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			dig_immediate = {times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			fleshy =	{times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			choppy =	{times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			bendy =		{times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			cracky =	{times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			crumbly =	{times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3},
			snappy =	{times={[1] = 0, [2] = 0, [3] = 0}, uses=0, maxlevel = 3}
		},
		damage_groups = {fleshy = 1000}
	}
})

function dcb.kill_node(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "dcb:pick_admin" then
		if not minetest.check_player_privs( -- TODO FIXME
				puncher:get_player_name(), {server=true}) then
			puncher:set_wielded_item("")
			minetest.log("action", puncher:get_player_name() ..
			" tried to use an Admin Pickaxe.")
			return
		end

		local nn = minetest.get_node(pos).name
		if nn == "air" then return end
		minetest.log("action", puncher:get_player_name() ..
			" digs " .. nn ..
			" at " .. minetest.pos_to_string(pos) ..
			" using an Admin Pickaxe.")
		local node_drops = minetest.get_node_drops(nn, "dcb:pick_admin")
		for i=1, #node_drops do
			local add_node = puncher:get_inventory():add_item("main", node_drops[i])
			if add_node then minetest.add_item(pos, add_node) end
		end
		minetest.remove_node(pos)
		nodeupdate(pos)
	end
end

minetest.register_on_punchnode(function(pos, node, puncher)
	dcb.kill_node(pos, node, puncher)
end)
