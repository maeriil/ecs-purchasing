local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local purchase_event = require(ServerScriptService.Server.functions.purchase_event)
local jecs = require(ReplicatedStorage.Shared.jecs)
local collect = require(ReplicatedStorage.Shared.collect)
local c = require(ReplicatedStorage.Shared.components)
local networking = require(ReplicatedStorage.Shared.networking)
local product_ids = require(ReplicatedStorage.Shared.product_ids)
local ref = require(ReplicatedStorage.Shared.ref)

return function(world: jecs.World)
	local pair = jecs.pair
	local events = collect(networking.PurchaseEvents.RegularItem.OnServerEvent)
	local purchase_item = world
		:query(c.PurchaseCoinItem, c.PurchaseStatus)
		:with(pair(c.PurchaseStatus, jecs.Wildcard), pair(c.EventOf, c.PurchaseCoinItem))
		:cached()

	local product_id = product_ids.COIN_PRODUCT
	return function()
		-- In an actual game you typically might send the entity id of what the item you are purchasing as well
		-- This is an isolated example so I already know what item it is so I don't bother doing it
		for _, player, kind in events() do
			local event = purchase_event(world, {
				player = player,
				event = c.PurchaseCoinItem,
			})
			-- we want to ensure we are specifically targeting this item
			world:set(event, c.PurchaseCoinItem, kind)

			if kind == 1 then
				-- In this case, we have enough coin so we set the Purchase status to success basically
				world:set(event, c.PurchaseStatus, true)
			else
				-- We dont have enough coin so we prompt players ot purchase some money so we can buy this item. As soon as player buys this item, we automatically process this item as well
				-- If for instance we didn't want to specifically purchase this item as well, then we would just remove the c.PurchaseCoinItem for example
				MarketplaceService:PromptProductPurchase(player, product_id)
				world:add(event, c.PurchasePrompted)
			end
		end

		for id, kind, status in purchase_item do
			if status then
				print("Award the stuff or anything else blah blah blah (?)")

				-- datastore update here (?)
			else
				print("FAILED...")
			end

			world:delete(id)
		end
	end
end
