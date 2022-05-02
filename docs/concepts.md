### Summary
* [Concepts](#concepts)

## concepts

The Concepts module

It's just a collection of useful concepts around Rotor library traits.

Simple concepts list:

* `an_entity`: accepts any entity record.
* `an_entity_ptr`: accepts any entity record pointer.
* `an_genidx`: accepts any genidx record.
* `an_genidx_ptr`: accepts any genidx record pointer.
* `an_storage`: accepts any storage record.
* `an_storage_ptr`: accepts any storage record pointer.
* `an_component`: accepts any component record.
* `an_component_ptr`: accepts any component record pointer.
* `an_entity_with(filter)`: accepts any entity record that have the components passed on filter
* `an_entity_ptr_with(filter)`: accepts any entity record that have the components passed on filter

Usage:
```lua
local function orbital_bodies_hierarchy(entity_ptr: concepts.an_entity_ptr)
  -- ...
end

-- the filtered concepts requires an expression replacement since the function returns a concept.
local function position_hierarchy(entity_ptr: #[concepts.value.an_entity_ptr_with({Position.value})]#)
  -- ...
end
```

### Concepts

```lua
local Concepts = @record{}
```



---
