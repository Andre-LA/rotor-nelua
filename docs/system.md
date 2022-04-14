### Summary
* [system](#system)
* [system:run](#systemrun)
* [system](#system)

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

run the system by passing a variable count of entity storages pointers.

### system

```lua
local system: type
```

System generic used to instantiate an system runtime type in the form of `system(T)`, where:
* `T` is an "run" function (it doesn't need to be named as "run")
* the "run" function should have 2 arguments:
the 1st should be the system's record pointer (like the `self` argument when using the method syntax)
the 2nd should be a record of component pointers to be processed.

any no satisfied condition will result in a compile-time error.

---
