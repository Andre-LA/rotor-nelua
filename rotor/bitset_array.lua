--- bitsetarray library
-- @module bitset_array

local operations = require ("rotor.lua5x-operations")

-- from Lua Manual: lua.org/manual/5.3/manual.html#3.4.2
-- Lua supports the following bitwise operators:

local op_band   = operations.band   -- &  bitwise AND
local op_bor    = operations.bor    -- |  bitwise OR
local op_bxor   = operations.bxor   -- ~  bitwise XOR
local op_rshift = operations.rshift -- >> right shift
local op_lshift = operations.lshift -- << left shift
local op_bnot   = operations.bnot   -- ~  bitwise NOT

local LEFTMOSTBIT = op_bnot(op_rshift(op_bnot(0), 1))

local bitset_array_lib = {}

local bitset_array_mt = {
   __index = bitset_array_lib
}

-- locals prototypes, maybe is unnecessary, but using locals are faster and some functions
-- of this library are called with very high frenquency.
local copy;
local equals;
local band;
local bor;
local bxor;
local bnot;
local lshift;
local rshift;
local new;

local function do_bin_bitop(left_bitset_array, right_bitset_array, default_vl, bitop_func)
   local len_l, len_r = #left_bitset_array, #right_bitset_array
   local len = len_l > len_r and len_l or len_r
   local result = new(len)

   for i=1, len do
      result[i] = bitop_func(left_bitset_array[i] or default_vl, right_bitset_array[i] or default_vl)
   end

   return result
end

function bitset_array_lib.new (initial_length, initial_value)
   initial_value = initial_value or {}

   local new_bitset_array = {initial_value[1] or 0}

   for i=2, (initial_length or 0) do
      new_bitset_array[i] = initial_value[i] or 0
   end

   setmetatable(new_bitset_array, bitset_array_mt)

   return new_bitset_array
end

function bitset_array_lib.copy(bitset_array)
   local new_bitset_array = new()

   for i = 1, #bitset_array do
      new_bitset_array[i] = bitset_array[i]
   end

   return new_bitset_array
end

function bitset_array_lib.equals(left_bitset_array, right_bitset_array)
   local len_l, len_r = #left_bitset_array, #right_bitset_array
   local len = len_l > len_r and len_l or len_r

   for i=1, len do
      if left_bitset_array[i] ~= right_bitset_array[i] then
         return false
      end
   end

   return true
end

function bitset_array_lib.band (left_bitset_array, right_bitset_array)
   return do_bin_bitop(left_bitset_array, right_bitset_array, 1, op_band)
end

function bitset_array_lib.bor (left_bitset_array, right_bitset_array)
   return do_bin_bitop(left_bitset_array, right_bitset_array, 0, op_bor)
end

function bitset_array_lib.bxor (left_bitset_array, right_bitset_array)
   return do_bin_bitop(left_bitset_array, right_bitset_array, 0, op_bxor)
end

function bitset_array_lib.bnot (bitset_array)
   local len = #bitset_array
   local result = new(len)

   for i = 1, #bitset_array do
      result[i] = op_bnot(bitset_array[i])
   end

   return result
end

function bitset_array_lib.lshift (bitset_array, steps)
   local len = #bitset_array
   local result = copy(bitset_array)

   for _ = 1, steps do
      local previous_contained_leftmost_bit = false
      local result_prev_step = copy(result)

      for i = 1, len do
         local contains_leftmost_bit = op_band(result_prev_step[i], LEFTMOSTBIT) == LEFTMOSTBIT

         result[i] = op_lshift(result_prev_step[i], 1)

         if previous_contained_leftmost_bit then
            result[i] = op_bor(result[i], 1)
         end

         previous_contained_leftmost_bit = contains_leftmost_bit
      end
   end

   return result
end

function bitset_array_lib.rshift (bitset_array, steps)
   local len = #bitset_array
   local result = copy(bitset_array)

   for _ = 1, steps do
      local previous_contained_rightmost_bit = false
      local result_prev_step = copy(result)

      for i = len, 1, -1 do
         local contains_rightmost_bit = op_band(result_prev_step[i], 1) == 1

         result[i] = op_rshift(result_prev_step[i], 1)

         if previous_contained_rightmost_bit then
            result[i] = op_bor(result[i], LEFTMOSTBIT)
         end

         previous_contained_rightmost_bit = contains_rightmost_bit
      end
   end

   return result
end

-- defining the locals
copy = bitset_array_lib.copy
equals = bitset_array_lib.equals
band = bitset_array_lib.band
bor = bitset_array_lib.bor
bxor = bitset_array_lib.bxor
bnot = bitset_array_lib.bnot
lshift = bitset_array_lib.lshift
rshift = bitset_array_lib.rshift
new = bitset_array_lib.new

return bitset_array_lib
