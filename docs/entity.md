### Summary
* [entity](#entity)

## entity

Entity generic used to instantiate an entity type in the form of `entity(T)`, where
`T` must be a record and all it's fields must be either components, entities or generational indexes,
otherwise it will result on a compile-time error.

Usage:

```lua
local entity = require 'rotor.entity'
local component = require 'rotor.component'

local Position = @component(@record{ x: number, y: number })
local Velocity = @component(@record{ x: number, y: number })
local Name = @component(string)

-- BasicEntity's type it's the record passed on the entity type constructor.
local BasicEntity = @entity(@record{
  position: Position,
  velocity: Velocity,
  name: Name,
})

-- BasicEntity's type it's the record passed on the entity type constructor.
local my_entity: BasicEntity = {
  position = { 10, 20 },
  velocity = { 30, 10 },
  name = "Foo"
}

-- but it also contains an `is_entity` trait.
## static_assert(BasicEntity.value.is_entity)
## static_assert(my_entity.type.is_entity)

-- an entity tree it's done by nesting child entities on it's fields
local ParentEntity = @entity(@record{
  position: Position,
  child: BasicEntity,
})

local parent: ParentEntity = {
  position = { 0, 0 },
  child = {
    position = { 30, 40 },
    velocity = { 10, 0 },
    name = "child entity",
  }
}
```

### entity

```lua
local entity: type
```



---
