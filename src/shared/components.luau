local jecs = require(script.Parent.jecs)
local world = require(script.Parent.world)

return {
	Client = world:component() :: jecs.Id<Player>,
	BasePart = world:component() :: jecs.Id<BasePart>,

	ProximityPrompt = world:component() :: jecs.Id<ProximityPrompt>,
	Triggered = world:entity() :: jecs.Entity,
	Event = world:component() :: jecs.Id<() -> () -> any>,
	Cleanup = world:component() :: jecs.Id<() -> ()>,
	EventOf = world:entity() :: jecs.Entity,

	Purchasing = world:entity() :: jecs.Entity,
	ProductId = world:component() :: jecs.Id<number>,
	PurchasePrompted = world:entity() :: jecs.Entity,
	PurchaseStatus = world:component() :: jecs.Id<boolean>,

	-- items
	-- ideally you won't store these here. Instead each item will have a server entity id that you send to the client side, and the client will do a EntityId get call to fire back to server.
	-- For demo purposes, I just directly create this in the components file
	PurchaseRobuxItem = world:entity() :: jecs.Entity,
	PurchaseCoinItem = world:component() :: jecs.Id<number>,
}
