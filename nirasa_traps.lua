nirasa_traps = {
  wood_durability_index = 0.4,
  iron_durability_index = 0.9,
  dia_durability_index = 200
}

-- add damage to any object.
nirasa_traps.do_damage = function(obj, durability_index)
  if obj == nil then return end

  if obj:is_player() or (obj:get_luaentity() ~= nil and obj:get_luaentity().name ~= "__builtin:item") then
    obj:punch(obj, 1.0, {full_punch_interval = 1.0, damage_groups = {fleshy=5}}, nil)
    if durability_index ~= nil and nirasa_traps.is_broken(durability_index) then
      return 1
    end
  end
  return 0
end

-- check nodes below/above to forbid construct spikes in two vertical rows.
nirasa_traps.is_allowed_position = function(pos)
  local node = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
  if minetest.get_node_group(node.name, "spikes") > 0 then
    return false
  end
  node = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
  if minetest.get_node_group(node.name, "spikes") > 0 then
    return false
  end
  return true
end

--ramdomly decide if spike is broken.
nirasa_traps.is_broken = function(durability_index)
  if (durability_index < math.random()) then
    return true
  end
  return false
end

minetest.register_node("nirasa_traps:wood_spikes", {
  description = "Wood spikes",
  drawtype = "plantlike",
  visual_scale = 1,
  tile_images = {"nirasa_traps_wood_spikes.png"},
  inventory_image = ("nirasa_traps_wood_spikes.png"),
  paramtype = "light",
  walkable = false,
  drop = "default:stick 3",
  sunlight_propagates = true,
  groups = {spikes=1, flammable=2, choppy = 2, oddly_breakable_by_hand = 1},
  on_punch = function(pos, node, puncher, tool_capabilities, pointed_thing)
    nirasa_traps.do_damage(puncher, nil)
  end,
})

minetest.register_node("nirasa_traps:broken_wood_spikes", {
  description = "Broken wood spikes",
  drawtype = "plantlike",
  visual_scale = 1,
  tile_images = {"nirasa_traps_broken_wood_spikes.png"},
  inventory_image = ("nirasa_traps_broken_wood_spikes.png"),
  paramtype = "light",
  walkable = false,
  sunlight_propagates = true,
  drop = "default:stick 3",
  groups = {spikes=1, flammable=2, choppy = 2, oddly_breakable_by_hand = 1},
})

minetest.register_craft({
  output = 'nirasa_traps:wood_spikes 3',
  recipe = {
    {'', '', ''},
    {'', 'default:stick', ''},
    {'default:stick', 'default:stick', 'default:stick'},
  },
})

minetest.register_node("nirasa_traps:iron_spikes", {
  description = "Iron spikes",
  drawtype = "plantlike",
  visual_scale = 1,
  tile_images = {"nirasa_traps_iron_spikes.png"},
  inventory_image = ("nirasa_traps_iron_spikes.png"),
  paramtype = "light",
  walkable = false,
  sunlight_propagates = true,
  drop = "default:steel_ingot 2",
  groups = {cracky=2, spikes=1},
  on_punch = function(pos, node, puncher, tool_capabilities, pointed_thing)
    nirasa_traps.do_damage(puncher, nil)
  end,
})

minetest.register_node("nirasa_traps:broken_iron_spikes", {
  description = "Broken iron spikes",
  drawtype = "plantlike",
  visual_scale = 1,
  tile_images = {"nirasa_traps_broken_iron_spikes.png"},
  inventory_image = ("nirasa_traps_broken_iron_spikes.png"),
  paramtype = "light",
  walkable = false,
  sunlight_propagates = true,
  drop = "default:steel_ingot 2",
  groups = {cracky=2, spikes=1},
})

minetest.register_craft({
  output = 'nirasa_traps:iron_spikes 3',
  recipe = {
    {'', '', ''},
    {'', 'default:steel_ingot', ''},
    {'default:steel_ingot', 'nirasa_traps:wood_spikes', 'default:steel_ingot'},
  },
})

minetest.register_abm(
  {nodenames = {"nirasa_traps:wood_spikes"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
      local times_broken = 0
      local objs = minetest.get_objects_inside_radius(pos, 1)
      for k, obj in pairs(objs) do
        times_broken = times_broken + nirasa_traps.do_damage(obj, nirasa_traps.wood_durability_index)
      end
      if times_broken > 0 then
        minetest.remove_node(pos)
        minetest.place_node(pos, {name="nirasa_traps:broken_wood_spikes"})
      end
    end,
  })

minetest.register_abm(
  {nodenames = {"nirasa_traps:iron_spikes"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
      local times_broken = 0
      local objs = minetest.get_objects_inside_radius(pos, 1)
      for k, obj in pairs(objs) do
        times_broken = times_broken + nirasa_traps.do_damage(obj, nirasa_traps.iron_durability_index)
      end
      if times_broken > 0 then
        minetest.remove_node(pos)
        minetest.place_node(pos, {name="nirasa_traps:broken_iron_spikes"})
      end
    end,
  })

--Diamond spikes
minetest.register_node("nirasa_traps:dia_spikes", {
  description = "Diamond spikes",
  drawtype = "plantlike",
  visual_scale = 1,
  tile_images = {"nirasa_traps_dia_spikes.png"},
  inventory_image = ("nirasa_traps_dia_spikes.png"),
  paramtype = "light",
  walkable = false,
  sunlight_propagates = true,
  drop = "default:diamond 2",
  groups = {cracky=2, spikes=1},
  on_punch = function(pos, node, puncher, pointed_thing)
    nirasa_traps.do_damage(puncher, nil)
  end,
})

minetest.register_node("nirasa_traps:broken_dia_spikes", {
  description = "Broken diamond spikes",
  drawtype = "plantlike",
  visual_scale = 1,
  tile_images = {"nirasa_traps_broken_dia_spikes.png"},
  inventory_image = ("nirasa_traps_broken_dia_spikes.png"),
  paramtype = "light",
  walkable = false,
  sunlight_propagates = true,
  drop = "default:diamond 2",
  groups = {cracky=2, spikes=1},
})

minetest.register_craft({
  output = 'nirasa_traps:dia_spikes 3',
  recipe = {
    {'', '', ''},
    {'', 'default:diamond', ''},
    {'default:diamond', 'nirasa_traps:iron_spikes', 'default:diamond'},
  },
})

minetest.register_abm(
  {nodenames = {"nirasa_traps:dia_spikes"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
      local times_broken = 0
      local objs = minetest.get_objects_inside_radius(pos, 1)
      for k, obj in pairs(objs) do
        times_broken = times_broken + nirasa_traps.do_damage(obj, nirasa_traps.dia_durability_index)
      end
      if times_broken > 0 then
        minetest.remove_node(pos)
        minetest.place_node(pos, {name="nirasa_traps:broken_dia_spikes"})
      end
    end,
  })
