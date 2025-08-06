local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.Shared.jecs)

type Remote<T...> = {
	FireClient: (Remote<T...>, Player, T...) -> (),
	FireAllClients: (Remote<T...>, T...) -> (),
	FireServer: (Remote<T...>, T...) -> (),
	OnServerEvent: RBXScriptSignal<(Player, T...)>,
	OnClientEvent: RBXScriptSignal<T...>,
}

local function stream_ensure(name)
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = ReplicatedStorage
	end
	return remote
end

type Entity = jecs.Entity
type Map<K, V> = { [K]: V }
type Array<T> = { T }

return {
	PurchaseEvents = {
		LimitedItem = stream_ensure("LimitedItem") :: Remote<>,
		RegularItem = stream_ensure("RegularItem") :: Remote<number>,
	},
}
