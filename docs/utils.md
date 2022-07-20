### Summary
* [utils](#utils)
* [utils.copy_entity](#utilscopy_entity)

## utils

The Utils module.

This module have some useful utility functions.

### utils

```lua
local utils = @record{}
```



### utils.copy_entity

```lua
function utils.copy_entity(another_entity: concepts.an_entity_ptr, new_entity_type: type): #[new_entity_type.value]#
```

Returns a value of type `new_entity_type`, whose components are copied from
the `another_entity` argument (which must be an entity).

Usage:
```lua
-- code taken from the `extend` example
function Warrior.init(name: string): Warrior
  local person = Person.init(name, Class.Warrior)

  local warrior = utils.copy_entity(&person, @Warrior)
  warrior.warrior_controller.atk = 100

  return warrior
end
```

---
