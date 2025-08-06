local ReplicatedStorage = game:GetService("ReplicatedStorage")

local c = require(ReplicatedStorage.Shared.components)
local jecs = require(ReplicatedStorage.Shared.jecs)

return function(world: jecs.World)
	return function()
		for id, event, _prompt in world:query(c.Event, c.ProximityPrompt):iter() do
			for _ in event() do
				world:add(id, c.Triggered)
			end
		end
	end
end
