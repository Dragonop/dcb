screwdriver = screwdriver or {}

xconnected.register_pane("xdecor:bamboo_frame", "xdecor_bamboo_frame.png", nil, {
	description = "Bamboo Frame",
	tiles = {"xdecor_bamboo_frame.png"},
	drawtype = "airlike",
	paramtype = "light",
	textures = {"xdecor_bamboo_frame.png", "xdecor_bamboo_frame.png", "xconnected_space.png"},
	inventory_image = "xdecor_bamboo_frame.png",
	wield_image = "xdecor_bamboo_frame.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, pane=1, flammable=2},
	sounds = default.node_sound_leaves_defaults()
})

xdecor.register("baricade", {
	description = "Baricade",
	drawtype = "plantlike",
	walkable = false,
	inventory_image = "xdecor_baricade.png",
	tiles = {"xdecor_baricade.png"},
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=3},
	damage_per_second = 4,
	selection_box = xdecor.nodebox.slab_y(0.3)
})

xdecor.register("barrel", {
	description = "Barrel",
	inventory = {size=24},
	infotext = "Barrel",
	tiles = {"xdecor_barrel_top.png", "xdecor_barrel_sides.png"},
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=3},
	sounds = default.node_sound_wood_defaults()
})

xdecor.register("cabinet", {
	description = "Wood Cabinet",
	inventory = {size=24},
	infotext = "Wood Cabinet",
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_rotate = screwdriver.rotate_simple,
	tiles = {"xdecor_cabinet_sides.png", "xdecor_cabinet_sides.png",
		 "xdecor_cabinet_sides.png", "xdecor_cabinet_sides.png",
		 "xdecor_cabinet_sides.png", "xdecor_cabinet_front.png"}
})

xdecor.register("cabinet_half", {
	description = "Half Wood Cabinet",
	inventory = {size=8},
	infotext = "Half Wood Cabinet",
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = xdecor.nodebox.slab_y(0.5, 0.5),
	tiles = {"xdecor_cabinet_sides.png", "xdecor_cabinet_sides.png",
		 "xdecor_half_cabinet_sides.png", "xdecor_half_cabinet_sides.png",
		 "xdecor_half_cabinet_sides.png", "xdecor_half_cabinet_front.png"}
})

xdecor.register("candle", {
	description = "Candle",
	light_source = 12,
	drawtype = "torchlike",
	inventory_image = "xdecor_candle_inv.png",
	wield_image = "xdecor_candle_wield.png",
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	walkable = false,
	groups = {dig_immediate=3, attached_node=1},
	tiles = {{name = "xdecor_candle_floor.png",
			animation = {type="vertical_frames", length=1.5}},
		{name = "xdecor_candle_ceiling.png",
			animation = {type="vertical_frames", length=1.5}},
		{name = "xdecor_candle_wall.png",
			animation = {type="vertical_frames", length=1.5}}
	},
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.3, -0.4, -0.3, 0.3, 0.5, 0.3},
		wall_bottom = {-0.25, -0.5, -0.25, 0.25, 0.1, 0.25},
		wall_side = {-0.5, -0.35, -0.15, -0.15, 0.4, 0.15}
	}
})

xdecor.register("chair", {
	description = "Chair",
	tiles = {"xdecor_wood.png"},
	sounds = default.node_sound_wood_defaults(),
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=3},
	on_rotate = screwdriver.rotate_simple,
	node_box = xdecor.pixelbox(16, {
		{3,  0, 11,   2, 16, 2},
		{11, 0, 11,   2, 16, 2},
		{5,  9, 11.5, 6,  6, 1},
		{3,  0,  3,   2,  6, 2},
		{11, 0,  3,   2,  6, 2},
		{3,  6,  3,   10, 2, 8}
	}),
	can_dig = xdecor.sit_dig,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		pos.y = pos.y + 0  -- Sitting position.
		xdecor.sit(pos, node, clicker, pointed_thing)
	end
})

xconnected.register_pane("xdecor:chainlink", "xdecor_chainlink.png", nil, {
	description = "Chain Link",
	tiles = {"xdecor_chainlink.png"},
	drawtype = "airlike",
	paramtype = "light",
	textures = {"xdecor_chainlink.png", "xdecor_chainlink.png", "xconnected_space.png"},
	inventory_image = "xdecor_chainlink.png",
	wield_image = "xdecor_chainlink.png",
	groups = {cracky=3, oddly_breakable_by_hand=2, pane=1},
	recipe = { {"default:steel_ingot", "", "default:steel_ingot"},
		   {"", "default:steel_ingot", ""},
		   {"default:steel_ingot", "", "default:steel_ingot"} }
})

-- The following nodedef is licensed under WTFPL for granting a possible re-use
-- in Minetest Game (https://github.com/minetest/minetest_game). 
xdecor.register("cobweb", {
	description = "Cobweb",
	drawtype = "plantlike",
	tiles = {"xdecor_cobweb.png"},
	inventory_image = "xdecor_cobweb.png",
	liquid_viscosity = 8,
	liquidtype = "source",
	liquid_alternative_flowing = "xdecor:cobweb",
	liquid_alternative_source = "xdecor:cobweb",
	liquid_renewable = false,
	liquid_range = 0,
	walkable = false,
	selection_box = {type = "regular"},
	groups = {dig_immediate=3, liquid=3, flammable=3},
	sounds = default.node_sound_leaves_defaults()
})

for _, c in pairs({"red", "darkgray", "black", "violet", "blue",
	"cyan", "darkgreen", "green", "yellow", "brown",
	"orange", "gray", "magenta", "pink"}) do
	xdecor.register("curtain_"..c, {
		description = c:gsub("^%l", string.upper).." Curtain",
		walkable = false,
		tiles = {"wool_white.png^[colorize:"..c..":170"},
		inventory_image = "wool_white.png^[colorize:"..c..":170^xdecor_curtain_open_overlay.png^[makealpha:255,126,126",
		wield_image = "wool_white.png^[colorize:"..c..":170",
		drawtype = "signlike",
		paramtype2 = "wallmounted",
		groups = {dig_immediate=3, flammable=3},
		selection_box = {type="wallmounted"},
		on_rightclick = function(pos, node)
			minetest.set_node(pos, {name="xdecor:curtain_open_"..c, param2=node.param2})
		end
	})

	xdecor.register("curtain_open_"..c, {
		tiles = {"wool_white.png^[colorize:"..c..":170^xdecor_curtain_open_overlay.png^[makealpha:255,126,126"},
		drawtype = "signlike",
		paramtype2 = "wallmounted",
		walkable = false,
		groups = {dig_immediate=3, flammable=3, not_in_creative_inventory=1},
		selection_box = {type="wallmounted"},
		drop = "xdecor:curtain_"..c,
		on_rightclick = function(pos, node)
			minetest.set_node(pos, {name="xdecor:curtain_"..c, param2=node.param2})
		end
	})

	minetest.register_craft({
		output = "xdecor:curtain_"..c.." 4",
		recipe = { {"", "wool:"..c, ""},
			   {"", "wool:"..c, ""} }
	})
end

xdecor.register("cushion", {
	description = "Cushion",
	tiles = {"xdecor_cushion.png"},
	groups = {snappy=3, flammable=3, fall_damage_add_percent=-50},
	on_place = minetest.rotate_node,
	node_box = xdecor.nodebox.slab_y(0.5),
	can_dig = xdecor.sit_dig,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		pos.y = pos.y + 0
		xdecor.sit(pos, node, clicker, pointed_thing)

		local wield_item = clicker:get_wielded_item():get_name()
		if wield_item == "xdecor:cushion" and clicker:get_player_control().sneak then
			local player_name = clicker:get_player_name()
			if minetest.is_protected(pos, player_name) then
				minetest.record_protection_violation(pos, player_name) return
			end

			minetest.set_node(pos, {name="xdecor:cushion_block", param2=node.param2})

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end
	end
})

xdecor.register("cushion_block", {
	tiles = {"xdecor_cushion.png"},
	groups = {snappy=3, flammable=3, fall_damage_add_percent=-75, not_in_creative_inventory=1}
})

local function door_access(door)
	if door:find("prison") then return true end
	return false
end

local door_types = {
	{"japanese", "brown"}, {"prison", "grey"}, {"prison_rust", "rust"},
	{"screen", "brownb"}, {"slide", "brownc"}, {"woodglass", "brown"}
}

for _, d in pairs(door_types) do
	doors.register_door("xdecor:"..d[1].."_door", {
		description = string.gsub(d[1]:gsub("^%l", string.upper), "_r", " R").." Door",
		inventory_image = "xdecor_"..d[1].."_door_inv.png",
		groups = {choppy=3, flammable=2, door=1},
		tiles_bottom = {"xdecor_"..d[1].."_door_b.png", "xdecor_"..d[2]..".png"},
		tiles_top = {"xdecor_"..d[1].."_door_a.png", "xdecor_"..d[2]..".png"},
		only_placer_can_open = door_access(d[1]),
		sounds = default.node_sound_wood_defaults(),
		sunlight = false
	})
end

xdecor.register("empty_shelf", {
	description = "Empty Shelf",
	inventory = {size=24},
	infotext = "Empty Shelf",
	tiles = {"default_wood.png", "default_wood.png^xdecor_empty_shelf.png"},
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_rotate = screwdriver.rotate_simple
})

xdecor.register("enderchest", {
	description = "Ender Chest",
	tiles = {"xdecor_enderchest_top.png", "xdecor_enderchest_top.png",
		 "xdecor_enderchest_side.png", "xdecor_enderchest_side.png",
		 "xdecor_enderchest_side.png", "xdecor_enderchest_front.png"},
	groups = {cracky=1, choppy=1, oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
	on_rotate = screwdriver.rotate_simple,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", [[ size[8,9]
				list[current_player;enderchest;0,0;8,4;]
				list[current_player;main;0,5;8,4;]
				listring[current_player;enderchest]
				listring[current_player;main] ]]
				..xbg..default.get_hotbar_bg(0,5))
		meta:set_string("infotext", "Ender Chest")
	end
})

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("enderchest", 8*4)
end)

xdecor.register("fire", {
	description = "Fancy Fire",
	drawtype = "plantlike",
	light_source = 14,
	walkable = false,
	tiles = {{ name = "xdecor_fire_anim.png",
		   animation = {type="vertical_frames", length=1.5 }}},
	damage_per_second = 4,
	drop = "",
	selection_box = xdecor.pixelbox(16, {{4, 0, 4, 8, 3, 8}}),
	groups = {dig_immediate=3, hot=3, not_in_creative_inventory=1}
})

xdecor.register("ivy", {
	description = "Ivy",
	drawtype = "signlike",
	walkable = false,
	climbable = true,
	groups = {dig_immediate=3, flammable=3, plant=1},
	paramtype2 = "wallmounted",
	selection_box = {type="wallmounted"},
	legacy_wallmounted = true,
	tiles = {"xdecor_ivy.png"},
	inventory_image = "xdecor_ivy.png",
	wield_image = "xdecor_ivy.png",
	sounds = default.node_sound_leaves_defaults()
})

xdecor.register("lantern", {
	description = "Lantern",
	light_source = 12,
	drawtype = "torchlike",
	inventory_image = "xdecor_lantern_floor.png",
	wield_image = "xdecor_lantern_floor.png", 
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	walkable = false,
	groups = {dig_immediate=3, attached_node=1},
	tiles = {"xdecor_lantern_floor.png", "xdecor_lantern_ceiling.png", "xdecor_lantern.png"},
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.25, -0.4, -0.25, 0.25, 0.5, 0.25},
		wall_bottom = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25},
		wall_side = {-0.5, -0.5, -0.15, 0.5, 0.5, 0.15}
	}
})

for _, l in pairs({"iron", "wooden"}) do
	xdecor.register(l.."_lightbox", {
		description = l:gsub("^%l", string.upper).." Light Box",
		tiles = {"xdecor_"..l.."_lightbox.png"},
		groups = {cracky=3, choppy=3, oddly_breakable_by_hand=2},
		light_source = 13,
		sounds = default.node_sound_glass_defaults()
	})
end

minetest.register_alias("xdecor:lightbox", "xdecor:wooden_lightbox")

xdecor.register("packed_ice", {
	drawtype = "normal",
	description = "Packed Ice",
	tiles = {"xdecor_packed_ice.png"},
	groups = {cracky=1, puts_out_fire=1},
	sounds = default.node_sound_glass_defaults()
})

for _, f in pairs({"dandelion_white", "dandelion_yellow", "geranium",
		"rose", "tulip", "viola"}) do
	xdecor.register("potted_"..f, {
		description = string.gsub("Potted Flowers ("..f..")", "_", " "),
		walkable = false,
		groups = {dig_immediate=3, flammable=3, plant=1, flower=1},
		tiles = {"xdecor_"..f.."_pot.png"},
		inventory_image = "xdecor_"..f.."_pot.png",
		drawtype = "plantlike",
		sounds = default.node_sound_leaves_defaults(),
		selection_box = xdecor.nodebox.slab_y(0.3)
	})

	minetest.register_craft({
		output = "xdecor:potted_"..f,
		recipe = { {"default:clay_brick", "flowers:"..f, "default:clay_brick"},
			   {"", "default:clay_brick", ""} }
	})
end

minetest.register_alias("xdecor:painting", "xdecor:painting_1")
xdecor.register("painting_1", {
	description = "Painting",
	tiles = {"xdecor_painting_1.png"},
	inventory_image = "xdecor_painting_empty.png",
	wield_image = "xdecor_painting_empty.png",
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	wield_image = "xdecor_painting_empty.png",
	sunlight_propagates = true,
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=3, attached_node=1},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "wallmounted",
		wall_top = {-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125},
		wall_bottom = {-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
		wall_side = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375}
	},
	on_construct = function(pos)
		local node = minetest.get_node(pos)
		local random = math.random(4)
		if random == 1 then return end
		minetest.set_node(pos, {name="xdecor:painting_"..random, param2=node.param2})
	end
})

for i = 2, 4 do
	xdecor.register("painting_"..i, {
		tiles = {"xdecor_painting_"..i..".png"},
		paramtype2 = "wallmounted",
		legacy_wallmounted = true,
		drop = "xdecor:painting_1",
		sunlight_propagates = true,
		groups = {choppy=3, oddly_breakable_by_hand=2, flammable=3, attached_node=1, not_in_creative_inventory=1},
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "wallmounted",
			wall_top = {-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125},
			wall_bottom = {-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			wall_side = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375}
		}
	})
end

for _, b in pairs({{"cactus", "cactus"}, {"moon", "stone"}}) do
	xdecor.register(b[1].."brick", {
		drawtype = "normal",
		description = b[1]:gsub("^%l", string.upper).." Brick",
		tiles = {"xdecor_"..b[1].."brick.png"},
		groups = {cracky=2},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_craft({
		output = "xdecor:"..b[1].."brick",
		type = "shapeless",
		recipe = {"default:brick", "default:"..b[2]}
	})
end

xdecor.register("multishelf", {
	description = "Multi Shelf",
	inventory = {size=24},
	infotext = "Multi Shelf",
	on_rotate = screwdriver.rotate_simple,
	tiles = {"default_wood.png", "default_wood.png^xdecor_multishelf.png"},
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=3},
	sounds = default.node_sound_wood_defaults()
})

xconnected.register_pane("xdecor:rust_bar", "xdecor_rust_bars.png", nil, {
	description = "Rusty Iron Bars",
	tiles = {"xdecor_rusty_bars.png"},
	drawtype = "airlike",
	paramtype = "light",
	textures = {"xdecor_rusty_bars.png", "xdecor_rusty_bars.png", "xconnected_space.png"},
	inventory_image = "xdecor_rusty_bars.png",
	wield_image = "xdecor_rusty_bars.png",
	groups = {cracky=3, oddly_breakable_by_hand=2, pane=1},
	sounds = default.node_sound_stone_defaults()
})

xdecor.register("stonepath", {
	description = "Garden Stone Path",
	tiles = {"default_stone.png"},
	groups = {snappy=3},
	on_rotate = screwdriver.rotate_simple,
	sounds = default.node_sound_stone_defaults(),
	sunlight_propagates = true,
	node_box = xdecor.pixelbox(16, {
		{8,  0,  8, 6, .5, 6},
		{1,  0,  1, 6, .5, 6},
		{1,  0, 10, 5, .5, 5},
		{10, 0,  2, 4, .5, 4}
	}),
	selection_box = xdecor.nodebox.slab_y(0.05)
})

for _, t in pairs({"desertstone_tile", "stone_tile", "stone_rune",
		"coalstone_tile", "hard_clay"}) do
	xdecor.register(t, {
		drawtype = "normal",
		description = string.gsub(" "..t, "%W%l", string.upper):sub(2):gsub("_", " "),
		tiles = {"xdecor_"..t..".png"},
		groups = {cracky=1},
		sounds = default.node_sound_stone_defaults()
	})
end

xdecor.register("table", {
	description = "Table",
	tiles = {"xdecor_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = xdecor.pixelbox(16, {
		{0, 14, 0, 16, 2, 16}, {5.5, 0, 5.5, 5, 14, 6}
	})
})

xdecor.register("tatami", {
	description = "Tatami",
	tiles = {"xdecor_tatami.png"},
	wield_image = "xdecor_tatami.png",
	groups = {snappy=3, flammable=3},
	node_box = xdecor.nodebox.slab_y(0.0625)
})

xdecor.register("tv", {
	description = "Television",
	light_source = 11,
	groups = {snappy=3},
	on_rotate = screwdriver.rotate_simple,
	tiles = { "xdecor_television_left.png^[transformR270",
		  "xdecor_television_left.png^[transformR90",
		  "xdecor_television_left.png^[transformFX",
		  "xdecor_television_left.png", "xdecor_television_back.png",
		{name = "xdecor_television_front_animated.png",
		 animation = {type="vertical_frames", length=80.0}} }
})

xconnected.register_pane("xdecor:wood_frame", "xdecor_wood_frame.png", nil, {
	description = "Wood Frame",
	tiles = {"xdecor_wood_frame.png"},
	drawtype = "airlike",
	paramtype = "light",
	textures = {"xdecor_wood_frame.png", "xdecor_wood_frame.png", "xconnected_space.png"},
	inventory_image = "xdecor_wood_frame.png",
	wield_image = "xdecor_wood_frame.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, pane=1, flammable=3},
	sounds = default.node_sound_wood_defaults()
})

xdecor.register("woodframed_glass", {
	description = "Wood Framed Glass",
	drawtype = "glasslike_framed",
	tiles = {"xdecor_woodframed_glass.png", "xdecor_woodframed_glass_detail.png"},
	groups = {cracky=3, oddly_breakable_by_hand=2},
	sounds = default.node_sound_glass_defaults()
})

xdecor.register("wood_tile", {
	description = "Wood Tile",
	tiles = {"xdecor_wood_tile.png"},
	drawtype = "normal",
	groups = {choppy=1, oddly_breakable_by_hand=1, wood=1, flammable=2},
	sounds = default.node_sound_wood_defaults()
})

