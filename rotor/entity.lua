--- entity library
-- @module entity

local bitset_array = require ("rotor.bitset_array")
local gen_id = require ("rotor.generational_index")

local table_insert, table_remove = table.insert, table.remove

local entity_lib = {}
local entity_mt = {
   __index = entity_lib
}

local function find(list, value_to_find, eq_function, list_name)
   for i = 1, #list do
      if eq_function(list[i], value_to_find) then
         return i
      end
   end

   return nil, list_name .. " index not found"
end

function entity_lib.new()
   local new_entity = {
      associated_components = {},
      associated_storages = {},
      mask = bitset_array.new(),
      untracked = true,
   }

   setmetatable(new_entity, entity_mt)
   return new_entity
end

function entity_lib.get_component_index(entity, component_gen_idx)
   return find(entity.associated_components, component_gen_idx, gen_id.equals, "component")
end

function entity_lib.get_storage_index(entity, storage_mask)
   return find(entity.associated_storages, storage_mask, bitset_array.equals, "storage")
end

function entity_lib.associate(entity, component_gen_idx, storage_mask)
   entity.mask = bitset_array.bor(entity.mask, storage_mask)
   table_insert(entity.associated_components, component_gen_idx)
   table_insert(entity.associated_storages, storage_mask)
end

function entity_lib.disassociate(entity, component_gen_idx_or_storage_mask)
   local is_bitset_array = #component_gen_idx_or_storage_mask > 0

   local get_index = is_bitset_array and entity_lib.get_storage_index or entity_lib.get_component_index
   local ok_index, err_msg = get_index(entity, component_gen_idx_or_storage_mask)

   if ok_index then
      entity.mask = bitset_array.band(entity.mask, bitset_array.bnot(entity.associated_storages[ok_index]))
      table_remove(entity.associated_components, ok_index)
      table_remove(entity.associated_storages, ok_index)
      return true
   else
      return nil, err_msg
   end
end

return entity_lib
