### Summary
* [storage](#storage)
* [storage:push](#storagepush)
* [storage:remove](#storageremove)
* [storage:mget](#storagemget)
* [storage:__mnext](#storage__mnext)
* [storage:__mpairs](#storage__mpairs)
* [storage:clear](#storageclear)
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
local storage = @record{
    entries: [SIZE]T,
    unavailables: [SIZE]boolean,
    generations: [SIZE]usize,
    next_idx: usize,
  }
```

the storage type

### storage:push

```lua
function storage:push(value: facultative(T)): (boolean, GenIdx, *T)
```

Push a new entry on the storage on the next free slot, if no free slots are available,
then a warning will be printed and this function will return `false`, a zeroed generational
index and `nilptr`.

Otherwise, the entry will be inserted on the found free slot and this function will return `true`,
the generational index of the used slot and a reference to the inserted entry.

You can optionally pass a value to initialize this entry.

### storage:remove

```lua
function storage:remove(idx: GenIdx, destroyer: facultative(function(*T))): boolean
```

Removes an entry associated with the generational index.

If the entry is found, then the slot it's zeroed and the function returns `true`. Othewise
it does nothing and returns `false`.

You can optionally pass a `destroyer` function, which will be called passing a pointer to
the entry, this is useful if you need to free resources on this entry.

### storage:mget

```lua
function storage:mget(idx: GenIdx): (boolean, *T)
```

Try to find the entry of the generational index.

If found, then it returns `true` and a reference to the entry on the storage. Otherwise, it
returns `false` and a `nilptr`.

To void undefined behavior, always check or assert the returned boolean value.

### storage:__mnext

```lua
function storage:__mnext(ctrl_var: isize): (boolean, isize, *T)
```

mnext method, used by `__mpairs` method, it finds the next entry to iterate.

### storage:__mpairs

```lua
function storage:__mpairs(): (auto, *storage, isize)
```

Iterator for `mpairs`, this allows using `for in` using the `mpairs` iterator on
the storage, it iterates only on the entries and skips unused slots.

### storage:clear

```lua
function storage:clear(on_clear: facultative(function(*T)))
```

resets storage to a zeroed state

### storage

```lua
local storage: type
```

Storage generic used to instantiate an storage type in the form of `component(T, size)`, where
`size` is the maximum number of entries.

---
