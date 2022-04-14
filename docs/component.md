### Summary
* [component](#component)
* [component](#component)

## component

Component generic used to instantiate an component type in the form of `component(T)`, where
`T` must be a record, otherwise it will result on a compile-time error.

### component

```lua
local component: type = @#[T]#
```



### component

```lua
local component: type
```

The component type of the module

Usage:

```lua
local component = require 'rotor.component'

local vec2 = @record{ x: number, y: number }

local Position = @component(@record{
  pos: vec2
})

-- Position's type it's the record passed on the component constructor.
local position: Position = { pos = { x = 10, y = 20 } }

-- but it also contains an `is_component` trait.
## static_assert(Position.value.is_component)
## static_assert(position.type.is_component)
```

---