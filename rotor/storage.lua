--- storage library
-- @module storage

local generational_index = require ("rotor.generational_index")
local new_id = generational_index.new

local storage_lib = {}
local storage_mt = {
   __index = storage_lib,
}

function storage_lib.new ()
   local new_storage = {
      next_free_ids = {new_id(1, 0)},
      entries = {},
      generations = {},
      len = 0
   } -- : storage

   setmetatable(new_storage, storage_mt)

   return new_storage
end

function storage_lib.new_entry(storage, entry_content)
   local next_free_ids = storage.next_free_ids -- ref
   local next_free_ids_len = #next_free_ids

   local last_free_id = next_free_ids[next_free_ids_len] -- ref

   local entry_index = last_free_id.index
   local entry_generation = last_free_id.generation

   storage.entries[entry_index] = entry_content
   storage.generations[entry_index] = entry_generation

   if entry_index > storage.len then -- storage needs to grow
      storage.len = entry_index -- assert(entry_index == storage.len + 1)
      last_free_id.index = entry_index + 1
      last_free_id.generation = 0
   else
      table.remove(next_free_ids)
   end

   -- return a copy of the gen_idx of this new entry
   return new_id(entry_index, entry_generation), entry_content
end

function storage_lib.get_entry(storage, gen_idx)
   local gen_idx_index = gen_idx.index

   if gen_idx.generation ~= storage.generations[gen_idx_index] then
      return nil, "entry not found"
   end

   return storage.entries[gen_idx_index]
end

function storage_lib.remove_entry(storage, gen_idx)
   local ok, err_msg = storage_lib.get_entry(storage, gen_idx)
   if not ok then
      return nil, err_msg
   end

   storage.entries[gen_idx.index] = nil
   storage.generations[gen_idx.index] = nil

   if gen_idx.index == storage.len then
      local last_i = 0
      for i=1, storage.len do
         if storage.generations[i] then
            last_i = i
         end
      end
      storage.len = last_i
   end

   table.insert(
      storage.next_free_ids,
      new_id(gen_idx.index, gen_idx.generation + 1)
   )

  return true
end

function storage_lib.iterate_entries(storage)
   local i, entries_len, entry_id = 0, storage.len, new_id(0, 0)

   return function ()
      local ok_entry;

      while ok_entry == nil and i < entries_len do
         i = i + 1
         entry_id.index, entry_id.generation = i, (storage.generations[i] or -1)
         ok_entry = storage_lib.get_entry(storage, entry_id)
      end

      return ok_entry, entry_id
   end
end

return storage_lib
