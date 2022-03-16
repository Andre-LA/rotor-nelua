### Summary
* [storage](#storage)

## storage

The storage module, it's a type constructor where you pass a type `T` and a non-zero positive
integer `size` value.

The result is a storage type capable of storing `size` entries of type `T`, always re-using
free slots as possible.

For example, if you use a storage capable of storing 3 entries and you push 3 entries on it,
and then removes the second entry, then a fourth entry can be pushed and it will use the second
slot, thus the generational index of this fourth entry will be a second generation of the second slot.

### storage

```lua
local storage: type
```

Storage generic used to instantiate an storage type in the form of `component(T, size)`, where
`size` is the maximum number of entries.

---
