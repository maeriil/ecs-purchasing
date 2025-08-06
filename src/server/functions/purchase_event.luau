local ReplicatedStorage = game:GetService("ReplicatedStorage")

local c = require(ReplicatedStorage.Shared.components)
local jecs = require(ReplicatedStorage.Shared.jecs)
local ref = require(ReplicatedStorage.Shared.ref)

return function(
	world: jecs.World,
	props: {
		player: Player,
		event: jecs.Entity,
	}
)
	local client_id = ref(props.player)
	local pair = jecs.pair
	local e = world:entity()
	jecs.bulk_insert(world, e, {
		pair(c.Purchasing, client_id),
		pair(c.EventOf, props.event),
	}, {
		nil,
		nil,
	})

	return e
end
