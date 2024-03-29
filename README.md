# Rotor

Rotor an ECS written in [Nelua][nelua-website].

Please check the [docs](docs) and the [examples](examples).

## Simple Example

```lua
local math = require 'math'
local os   = require 'os'
local io   = require 'io'

local storage   = require 'rotor.storage'
local component = require 'rotor.component'
local entity    = require 'rotor.entity'
local system    = require 'rotor.system'

-- components --
local Position = @component(@record{ x: integer, y: integer })
local Velocity = @component(@record{ x: integer, y: integer })
local Name     = @component(@record{ data: string })

local Rightmost = @record{
  pos: Position,
  name: Name
}

-- systems --
local MovementSystem = @record{}

function MovementSystem:run(c: record{vel: *Velocity, pos: *Position})
  c.pos.x = c.pos.x + c.vel.x
  c.pos.y = c.pos.y + c.vel.y
end

local RightmostSystem = @record{
  rightmost: Rightmost,
}

function RightmostSystem:init()
  self.rightmost.pos.x = math.mininteger
end

function RightmostSystem:run(c: record{pos: *Position, name: *Name})
  if c.pos.x > self.rightmost.pos.x then
    self.rightmost.pos = $c.pos
    self.rightmost.name = $c.name
  end
end

local Systems = @record{
  movement_system: system(MovementSystem.run),
  rightmost_system: system(RightmostSystem.run),
}

-- entity --
local BasicEntity = @entity(@record{
  position: Position,
  velocity: Velocity,
  name: Name,
})

-- setup --
local entity_storage: storage(BasicEntity, 64)
local systems: Systems

systems.rightmost_system.data:init()

-- let's create 64 entities!
print 'creating!'

for i = 0, < 64 do
  math.randomseed(os.time())

  -- create a new entity with an position, velocity and name
  local ok, id, entity = entity_storage:push({
    position = { x = math.random(-100, 100), y = i },
    velocity = { x = math.random(-200, 200), y = 0 },
    name = { 'some entity' },
  })
  assert(ok)
  assert(entity.name.data == 'some entity')
end

-- running --
-- let's execute movement system 10 times
for _ = 1, 10 do
  print ('executing movement system')
  systems.movement_system:run(&entity_storage)
end

print ('executing rightmost system')
systems.rightmost_system:run(&entity_storage)

local rightmost = systems.rightmost_system.data.rightmost

io.printf("entity '%s' is in the rightmost position.x: %d\n", rightmost.name.data, rightmost.pos.x)
```

[nelua-website]: https://nelua.io/ "nelua's website"
