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

local vec2 = @record{ x: number, y: number }

local Position = @component(vec2)
local Velocity = @component(vec2)
local Name = @component(string)

-- BasicEntity's type it's the record passed on the entity constructor.
local BasicEntity = @entity(@record{
  position: Position,
  velocity: Velocity,
  name: Name,
})

-- BasicEntity's type it's the record passed on the entity constructor.
local my_entity: BasicEntity = {
  position = { 10, 20 },
  velocity = { 30, 10 },
  name = "Foo"
}

-- but it also contains an `is_entity` trait.
## static_assert(BasicEntity.value.is_entity)
## static_assert(my_entity.type.is_entity)

-- a child entity it's just a field of the parent entity
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
