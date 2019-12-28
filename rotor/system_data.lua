--- system_data library
-- @module system_data

local bitset_array = require ("rotor.bitset_array")
local storage = require ("rotor.storage")
local generational_index = require ("rotor.generational_index")
local entity = require ("rotor.entity")
local union = require ("rotor.lua5x-operations").union

local system_data_lib = {}
local system_data_mt = {
   __index = system_data_lib
}

function system_data_lib.new(read_components, write_components)
   local mask_read, mask_write = bitset_array.new(), bitset_array.new()

   if not write_components then
      write_components = {}
   end

   for i = 1, #read_components do
      mask_read = bitset_array.bor(mask_read, read_components[i])
   end
   for i = 1, #write_components do
      mask_write = bitset_array.bor(mask_write, write_components[i])
   end

   local new_system_data = {
      mask = bitset_array.bor(mask_read, mask_write),
      mask_write = mask_write,
      required_storages = union(read_components, write_components),
      components_indexes = {},
      available_indexes = {},
   }

   setmetatable(new_system_data, system_data_mt)
   return new_system_data
end

local function collect_components(system_data, entity_i)
   local ba_equals = bitset_array.equals
   local components_tuple, n = {}, 0

   -- for each required storage, insert the components indexes respectively
   for i = 1, #system_data.required_storages do
      for j = 1, #entity_i.associated_storages do
         if ba_equals(system_data.required_storages[i], entity_i.associated_storages[j]) then
            n = n + 1
            components_tuple[n] = entity_i.associated_components[i]
            break
         end
      end
   end

   return components_tuple
end

function system_data_lib.update(system_data, entities_storage, untracked_ids)
   local available_indexes = system_data.available_indexes -- ref

   for i = 1, #untracked_ids do
      local entity_id = untracked_ids[i]
      local i_entity = storage.get_entry(entities_storage, entity_id)

      if i_entity then -- this is a new entity
         local masks_intersection = bitset_array.band(i_entity.mask, system_data.mask)

         if bitset_array.equals(masks_intersection, system_data.mask) then
            local idx_to_insert = 0

            local available_indexes_len = #available_indexes
            if available_indexes_len > 0 then
               idx_to_insert = available_indexes[available_indexes_len]
               table.remove(available_indexes)
            else
               idx_to_insert = #system_data.components_indexes + 1
            end

            system_data.components_indexes[idx_to_insert] = collect_components(system_data, i_entity)
         end
      end
   end
end

function system_data_lib.mark_available(system_data, idx)
   table.insert(system_data.available_indexes, idx)
   system_data.components_indexes[idx] = false
end

return system_data_lib
