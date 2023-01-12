### Summary
* [system](#system)
* [system:run](#systemrun)
* [system](#system)

## system

The system module.

System generic used to instantiate an system runtime type in the form of `system(T, order, is_reversed)`, where:
* `T` is an "run" function (it doesn't need to be named as "run")
  - the "run" function should have 2 or 3 parameters:
    * the 1st should be the system's record pointer (the `self` parameter when using the method syntax)
    * the 2nd should be a record of either component or entity pointers to be processed.
    * the 3rd parameter it's optional, if given, it should be an entity parameter or an entity concept.
* order it's an optional argument, where it must be either "pre-order" or "post-order"; if not given the "pre-order" value it's used.
* is_reversed it's an optional argument, it sets the order of children passed to systems.

Any no satisfied condition should result in a compile-time error.

About the order and is_reversed argument:

This option it's only useful when dealing with entity trees, when the value it's "pre-order", the system will first run
on the parent entities and then on the children entities, however when the value it's "post-order", then it will
run on children first and then on parents.

is_reversed reverses the children order on system calls, the order itself it's the order of entity fields on the entity record.

(See more about here: https://en.wikipedia.org/wiki/Tree_traversal#Depth-first_search)

Usage:
```lua
local MovementSystem = @record{}

function MovementSystem:run(c: record{vel: *Velocity, pos: *Position})
  c.pos.x = c.pos.x + c.vel.x
  c.pos.y = c.pos.y + c.vel.y
end

-- ...

local movement_system: system(MovementSystem.run)

-- ...

movement_system:run(&my_entity_storage)
```

For a better understanding, see the examples.

### system

```lua
local system: type = @record{
    data: systemdata,
  }
```



### system:run

```lua
function system:run(...: varargs)
```

Run the system by passing a variable count of entity storage pointers or entity pointers.

When passing an entity pointer, then the system will be called passing the entity components.

Usage:
```lua
-- Run the movement system on all player entities and then all the enemy entities.
movement_system:run(&players_storage, &enemies_storage)

-- Run the movement_system on the an specific player entity and then all the enemy entities
movement_system:run(&player_entity, &enemies_storage)
```

### system

```lua
local system: type
```



---
