-- operations using 5.2 features

-- Alert: I did not tested this yet!

return {
   -- bit operations
   band   = bit32.band,
   bor    = bit32.bor,
   bxor   = bit32.bxor,
   lshift = bit32.lshift,
   rshift = bit32.rshift,
   bnot   = bit32.bnot,
   unpack = table.unpack,
   union  =  function (a, b)
      local t, a_len = {}, #a
      for i = 1, #a do t[i] = a[i] end
      for i = 1, #b do t[i+a_len] = b[i] end
      return t
   end
}
