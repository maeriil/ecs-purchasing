local ReplicatedStorage = game:GetService("ReplicatedStorage")

local c = require(ReplicatedStorage.Shared.components)
local create_proximity = require(ReplicatedStorage.Shared.create_proximity)
local jecs = require(ReplicatedStorage.Shared.jecs)
local networking = require(ReplicatedStorage.Shared.networking)

return function(world: jecs.World)
	local pair = jecs.pair

	-- Just gonna setup the proximity right here because I am lazy
	-- the first one is enough money to purchase
	local part = Instance.new("Part")
	part.Size = Vector3.new(1, 1, 1)
	part.Position = Vector3.new(3, 0.5, 0)
	part.Color = Color3.fromRGB(0, 255, 0)
	part.Anchored = true
	part.Parent = workspace
	local parent_id = world:entity()
	world:set(parent_id, c.BasePart, part)
	world:add(parent_id, c.PurchaseCoinItem)

	create_proximity({
		action_text = "Purchase item with coins",
		parent_id = parent_id,
		parent = part,
	})

	-- the second one is not enough money to purchase

	return function()
		for id in world:each(c.PurchaseCoinItem) do
			local value = world:get(id, c.PurchaseCoinItem) :: number
			for proximity_id in world:query(c.Triggered, pair(c.EventOf, id)) do
				networking.PurchaseEvents.RegularItem:FireServer(value)

				world:remove(proximity_id, c.Triggered)
			end
		end
	end
end
