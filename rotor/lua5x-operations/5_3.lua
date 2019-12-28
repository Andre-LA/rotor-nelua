-- operations using 5.3 features

local move = table.move

return {
   -- bit operations
   band   = function (l, r) return l & r end,
   bor    = function (l, r) return l | r end,
   bxor   = function (l, r) return l ~ r end,
   lshift = function (l, r) return l << r end,
   rshift = function (l, r) return l >> r end,
   bnot   = function (v) return ~v end,
   unpack = table.unpack,
   union  =  function (a, b)
      local t, a_len = {}, #a
      for i = 1, #a do t[i] = a[i] end
      for i = 1, #b do t[i+a_len] = b[i] end
      return t
   end
}
