### Summary
* [Concepts](#concepts)
* [Concepts.an_entity](#conceptsan_entity)
* [Concepts.an_entity_ptr](#conceptsan_entity_ptr)
* [Concepts.an_genidx](#conceptsan_genidx)
* [Concepts.an_genidx_ptr](#conceptsan_genidx_ptr)
* [Concepts.an_storage](#conceptsan_storage)
* [Concepts.an_storage_ptr](#conceptsan_storage_ptr)
* [Concepts.an_component](#conceptsan_component)
* [Concepts.an_component_ptr](#conceptsan_component_ptr)
* [Concepts.an_system](#conceptsan_system)
* [Concepts.an_system_ptr](#conceptsan_system_ptr)

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
* `an_system`: accepts any system value.
* `an_system_ptr`: accepts any system pointer.
* `an_entity_with(filter)`: accepts any entity record that have the components passed on filter
* `an_entity_ptr_with(filter)`: accepts any entity record that have the components passed on filter
* `an_entity_subset(entity_type)`: accepts any entity record that have at least the components of entity_type.
* `an_entity_subset_ptr(entity_type)`: accepts any entity record that have at least the components of entity_type.

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



### Concepts.an_entity

```lua
local Concepts.an_entity
```



### Concepts.an_entity_ptr

```lua
local Concepts.an_entity_ptr
```



### Concepts.an_genidx

```lua
local Concepts.an_genidx
```



### Concepts.an_genidx_ptr

```lua
local Concepts.an_genidx_ptr
```



### Concepts.an_storage

```lua
local Concepts.an_storage
```



### Concepts.an_storage_ptr

```lua
local Concepts.an_storage_ptr
```



### Concepts.an_component

```lua
local Concepts.an_component
```



### Concepts.an_component_ptr

```lua
local Concepts.an_component_ptr
```



### Concepts.an_system

```lua
local Concepts.an_system
```



### Concepts.an_system_ptr

```lua
local Concepts.an_system_ptr
```



---
