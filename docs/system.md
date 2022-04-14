### Summary
* [system](#system)
* [system:run](#systemrun)
* [system](#system)

## system

The system module.

System generic used to instantiate an system runtime type in the form of `system(T)`, where:
* `T` is an "run" function (it doesn't need to be named as "run")
* the "run" function should have 2 arguments:
  - the 1st should be the system's record pointer (like the `self` argument when using the method syntax)
  - the 2nd should be a record of component pointers to be processed.

Any no satisfied condition will result in a compile-time error.

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

Run the system by passing a variable count of entity storage pointers.

Usage:
```lua
-- Run the movement system on all player entities and then all the enemy entities.
movement_system:run(&players_storage, &enemies_storage)
```

### system

```lua
local system: type
```



---
