--- lua5x-operations
-- @module lua5x-operations
-- Table with simple operations that are not compatible between
-- versions 5.1, 5.2 and 5.3 this is done by
-- `require ('lua5x-operations.' .. _VERSION:sub(-3):gsub("(%.)", "_"))`
-- @usage
-- local operations = "lua5x-operations"

local targetmodule =
   "rotor.lua5x-operations." .. (_VERSION:sub(-3):gsub("(%.)", "_"))

local operations = require (targetmodule)
return operations

--- the << operation.
-- @function lshift
-- @tparam number left
-- @tparam number right
-- @treturn number result
-- @usage
-- local operations = require 'lua5x-operations'
-- local lshift = operations.lshift
-- local a = 1 -- 0b0001
-- print(lshift(a, 1)) -- prints "2" (0b0010)
-- print(lshift(a, 2)) -- prints "4" (0b0100)
-- print(lshift(a, 3)) -- prints "8" (0b1000)

--- the >> operation.
-- @function rshift
-- @tparam number left
-- @tparam number right
-- @treturn number result
-- @usage
-- local operations = require 'lua5x-operations'
-- local rshift = operations.rshift
-- local a = 8 -- 0b1000
-- print(rshift(a, 1)) -- prints "4" (0b0100)
-- print(rshift(a, 2)) -- prints "2" (0b0010)
-- print(rshift(a, 3)) -- prints "1" (0b0001)

--- the & operation.
-- @function band
-- @tparam number left
-- @tparam number right
-- @treturn number result
-- @usage
-- local operations = require 'lua5x-operations'
-- local band = operations.band
-- local a = 1 -- 0b01
-- local b = 3 -- 0b11
-- print(band(a, b)) -- prints "1" (0b01)

--- the | operation.
-- @function bor
-- @tparam number left
-- @tparam number right
-- @treturn number result
-- @usage
-- local operations = require 'lua5x-operations'
-- local bor = operations.bor
-- local a = 1 -- 0b01
-- local b = 3 -- 0b11
-- print(bor(a, b)) -- prints "3" (0b11)

--- the ~ (binary) operation.
-- @function bxor
-- @tparam number left
-- @tparam number right
-- @treturn number result
-- @usage
-- local operations = require 'lua5x-operations'
-- local bxor = operations.bxor
-- local a = 1 -- 0b01
-- local b = 3 -- 0b11
-- print(bxor(a, b)) -- prints "2" (0b10)

--- the ~ (unary) operation.
-- @function bnot
-- @tparam number number
-- @treturn number result
-- @usage
-- local operations = require 'lua5x-operations'
-- local bnot = operations.bnot
-- local a = ~0 -- all bits are 1
-- print(bnot(a)) -- prints "0"
