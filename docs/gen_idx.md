### Summary
* [GenIdx](#genidx)
* [GenIdx.__eq](#genidx__eq)

## gen_idx

Generational Index module

### GenIdx

```lua
local GenIdx = @record{
  index: usize,      -- 0-based, since this is an index for arrays
  generation: usize, -- 1-based: 1 is the "first" valid generation, 0 is invalid
}
```

Generational Indexes, it identifies an index with a generation, making
each index unique between re-uses.

### GenIdx.__eq

```lua
function GenIdx.__eq(l: GenIdx, r: GenIdx): boolean
```

Equality test for generational indexes

It compares if the index and the generation of both operands are equal

---
