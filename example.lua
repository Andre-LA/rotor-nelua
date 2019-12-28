local entity = require ("rotor.entity")
local storage = require ("rotor.storage")
local system_data = require ("rotor.system_data")
local bitset_array = require ("rotor.bitset_array")

-- our components
local function create_position (x, y)
   return {x = x, y = y}
end

local function create_velocity (x, y)
   return {x = x, y = y}
end

-- is not a component, but will be processed by a system
local function create_rightmost()
   return {
      pos_comp = 0,
      name_comp = 0
   }
end

-- storages, its where components and entities will live
local storages = {
   position = storage.new(),
   velocity = storage.new(),
   entity = storage.new(),
   name = storage.new()
}

-- masks
local masks = {
   position = bitset_array.new(1, {1}),
   velocity = bitset_array.new(1, {1}):lshift(1),
   name     = bitset_array.new(1, {1}):lshift(2)
}

-- systems data
local systems_data = {
   movement  = system_data.new({masks.velocity}, {masks.position}),
   rightmost = system_data.new({masks.name, masks.position})
}

-- systems are just functions, here we have 2 examples
-- movement_system is more "functional", using arguments instead of locals declared above.
-- rightmost_system will use the locals
-- anyway, do what you think is better, is just a function ;)

local function movement_system(mov_system_data, velocity_storage, position_storage)
   local i = 1, #mov_system_data.components_indexes do
      local ids = mov_system_data.components_indexes[i]

      if ids then
         local vel_id, pos_id = ids[1], ids[2]

         local vel = velocity_storage:get_entry(vel_id)
         local pos = position_storage:get_entry(pos_id)

         if pos and vel then
            pos.x = pos.x + vel.x
            pos.y = pos.y + vel.y
         else
            mov_system_data:mark_available(i)
         end
      end
   end
end

local function rightmost_system(rightmost)
   local rightmost_position = -99999999

   for i = 1, #systems_data.rightmost.components_indexes do
      local ids = systems_data.rightmost.components_indexes[i]

      if ids then
         local name_id, pos_id = ids[1], ids[2]
         local name = storages.name:get_entry(name_id)
         local pos  = storages.position:get_entry(pos_id)

         if name and pos then
            if pos.x > rightmost_position then
               rightmost_position  = pos.x
               rightmost.pos_comp  = pos -- note: this is a reference
               rightmost.name_comp = name
            end
         else
            systems_data.rightmost:mark_available(i)
         end
      end
   end
end

-- here, we will store the ids
local names_ids = {}

-- also, we need to store the ids of created and removed entities ids
local untracked_entities_ids = {}

-- let's create 3 entities!
for i = 1, 3 do
   -- create an entity in the entities storage and get this new entity
   local new_entity_id, new_entity = storages.entity:new_entry(entity.new())

   -- btw, this is how you get an entry:
   -- local new_entity = entities_storage:get_entry(new_entity_id)

   -- create the components in their respective storages.
   -- storage.new_entry(value) returns a generational_index, it's used as an ID
   -- create_position(x, y) returns just a new very simple table, remember?
   local new_position_id = storages.position:new_entry(create_position(math.random(-100.0, 100.0), i))
   local new_velocity_id = storages.velocity:new_entry(create_velocity(math.random(-200.0, 200.0), 0))

   -- storages accepts any value
   names_ids[i] = storages.name:new_entry("entity #" .. i)

   -- this is how we associate an entity with a storage entry;
   -- making a unique bitmask per storage is necessary
   new_entity:associate(new_position_id, masks.position)
   new_entity:associate(new_velocity_id, masks.velocity)
   new_entity:associate(names_ids[i], masks.name)

   -- storing the new entity id
   table.insert(untracked_entities_ids, new_entity_id)
end

-- now, we update the systems datas, so they will know what entities
-- should be processed
systems_data.movement:update(storages.entity, untracked_entities_ids)
systems_data.rightmost:update(storages.entity, untracked_entities_ids)

-- let's execute movement system 10x
for _ = 1, 10 do
   movement_system(systems_data.movement, storages.velocity, storages.position)
end

local rightmost = create_rightmost()

-- let's execute rightmost_system, note that 'rigtmost' variable
-- is not an storage, component, or something specific;
-- since systems are just functions that you can declare and use
-- in whathever way you want, there is absolutely no special thing
-- in executing systems, they are just functions.
rightmost_system(rightmost)

local n = 1
for e, e_id in storages.entity:iterate_entries() do
  -- note: methods are implemented using metatable and __index field,
  -- so, in all libraries used, methods are optional,
  -- you can use (and localize for performance) the function
  -- from the libraries

  entity.disassociate(e, masks.position)

  local disassociate = entity.disassociate
  disassociate(e, masks.velocity)

  -- you can also disassociate using the entry generational index
  e:disassociate(names_ids[n])
  n = n + 1
end

local name, pos_x = rightmost.name_comp, rightmost.pos_comp.x

print (
  'entity "'
  .. tostring(name)
  .. '" is in the rightmost position x: '
  .. tostring(pos_x)
)
