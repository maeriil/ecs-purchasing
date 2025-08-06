local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local collect = require(ReplicatedStorage.Shared.collect)
local c = require(ReplicatedStorage.Shared.components)
local jecs = require(ReplicatedStorage.Shared.jecs)
local ref = require(ReplicatedStorage.Shared.ref)

return function(world: jecs.World)
	-- This is for Dev Product. For gamepasses, its pretty easy to just directly update them in the process receipt. But if you want to use this similar process, you could just recreate this but for gamepasses too
	local events = collect(MarketplaceService.PromptProductPurchaseFinished)
	local pair = jecs.pair

	return function()
		local deletion = {} :: { jecs.Entity }
		for _, player_user_id, product_id, status in events() do
			local player = Players:GetPlayerByUserId(player_user_id) :: Player
			local client_id = ref(player)

			--[[
			    Iterate over all the products that a player is attempting to purchase atm
			]]
			for id, i_product_id in world:query(c.ProductId, pair(c.Purchasing, client_id)) do
				if product_id ~= i_product_id then
					continue
				end

				--[[
				    status = false means that player pressed cancel, which means we can just safely delete this purchasing entity
				]]
				if not status then
					table.insert(deletion, id)
				end
			end
		end

		for i = #deletion, 1, -1 do
			local e = deletion[i]
			world:delete(e)

			deletion[i] = nil
		end
	end
end
