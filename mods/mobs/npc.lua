
-- Npc by TenPlus1

mobs.npc_drops = {
	--[[
	"default:pick_steel", "mobs:meat", "default:sword_steel",
	"default:shovel_steel", "farming:bread", "bucket:bucket_water",
	"default:book"
	--]]
	"crops:tomato_seed", "crops:potato_eyes", "crops:green_bean_seed",
	"crops:melon_seed", "crops:carrot_seeds", "crops:corn"
}

mobs:register_mob("mobs:npc", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	pathfinding = true,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "character.b3d",
	drawtype = "front",
	textures = {
		{"mobs_npc.png"},
		{"mobs_npc2.png"}, -- female by nuttmeg20
	},
	child_texture = {
		{"mobs_npc_baby.png"}, -- derpy baby by AmirDerAssassine
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 2,
	run_velocity = 3,
	jump = true,
	drops = {
		{name = "default:wood", chance = 1, min = 1, max = 3},
		{name = "default:apple", chance = 2, min = 1, max = 2},
		{name = "default:axe_stone", chance = 5, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 2,
	light_damage = 0,
	follow = {"farming:bread", "mobs:meat", "default:diamond"},
	view_range = 15,
	owner = "",
	order = "follow",
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

		-- feed to heal npc
		if mobs:feed_tame(self, clicker, 8, true, true) then
			return
		end

		local item = clicker:get_wielded_item()

		-- right clicking with gold lump drops random item from mobs.npc_drops
		if item:get_name() == "default:gold_lump" or
				item:get_name() == "default:gold_ingot" or
				item:get_name() == "shop:coin" then

			if not minetest.setting_getbool("creative_mode") then
				item:take_item()
				clicker:set_wielded_item(item)
			end

			local pos = self.object:getpos()

			pos.y = pos.y + 0.5

			minetest.add_item(pos, {
				name = mobs.npc_drops[math.random(1, #mobs.npc_drops)]
			})

			return
		end

		-- capture npc with net or lasso
		mobs:capture_mob(self, clicker, 0, 5, 80, false, nil)

		-- by right-clicking owner can switch npc between follow and stand
		if self.owner and self.owner == clicker:get_player_name() then

			if self.order == "follow" then
				self.order = "stand"
			else
				self.order = "follow"
			end
		end

	end,
})

--mobs:register_spawn("mobs:npc", {"default:apple", "shop:register"}, 20, 0, 1000, 2, 31000)
--mobs:spawn_specific("mobs:npc", {"default:brick"}, {"air"}, 0, 15, 1, 1, 1, 0, 200, true)

mobs:spawn_specific("mobs:npc", {"default:apple"}, {"air", "group:leaves"}, 0, 15, 30, 1000, 5, -31000, 31000)
mobs:spawn_specific("mobs:npc", {"shop:register"}, {"air"}, 0, 15, 30, 100, 2, -31000, 31000)

mobs:register_egg("mobs:npc", "NPC", "default_brick.png", 1)
