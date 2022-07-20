### Summary
* [extended](#extended)

## extended

Returns a new entity type that copies the fields of the `base_entity` type
(which must be an entity type), plus the `extra_components` fields

> Note: Only the record it's "cloned", not the methods, also this
is not an inheritance implementation, although it's used in a similar way.

Usage:
```lua
-- please read the `extend` and `extended_entity_tree` examples
-- to read how to use this feature in practice.

local entity = require 'rotor.entity'
local component = require 'rotor.component'
local extended = require 'rotor.extended'

-- person (the base)
local PersonController <nickname 'PersonController'> = @component(record{
  name: string,
})

local Person <nickname 'Person'> = @entity(record{
  person_controller: PersonController,
})

-- warrior
local WarriorController <nickname 'WarriorController'> = @component(record{
  atk: integer
})

local Warrior <nickname'Warrior'> = @extended(Person, record{
  warrior_controller: WarriorController,
})

-- wizard
local WizardController <nickname 'WizardController'> = @component(record{
  mp: integer
})

local Wizard <nickname 'Wizard'> = @extended(Person, record{
  wizard_controller: WizardController,
})

-- entity variables
local warrior: Warrior = {
  person_controller = { 'The Brave Warrior' },
  warrior_controller = { atk = 50 },
}

local wizard: Wizard = {
  person_controller = { 'The Clever Wizard' },
  wizard_controller = { mp = 150 },
}
```

### extended

```lua
local extended: type = @#[make_extended]#
```



---
