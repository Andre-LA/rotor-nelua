local generational_index_lib = {}
local generational_index_mt = {
   __index = generational_index_lib
}

function generational_index_lib.new(idx, gen)
   local new_generational_index = {
      index = idx,
      generation = gen
   }

   setmetatable(new_generational_index, generational_index_mt)
   return new_generational_index
end

function generational_index_lib.equals(g_idx_l, g_idx_r)
   return g_idx_l.index == g_idx_r.index and g_idx_l.generation == g_idx_r.generation
end

function generational_index_lib.copy(generational_index)
   return generational_index_lib.new(generational_index.index, generational_index.generation)
end

return generational_index_lib
