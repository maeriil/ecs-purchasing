local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(ReplicatedStorage.Shared.world)

type Tag = jecs.Entity

local refs: { [any]: Tag } = {}

local function fini(key): () -> ()
	return function()
		refs[key] = nil
	end
end

local function noop() end

local function set(key): (Tag, () -> ())
	if not key then
		return world:entity(), noop
	end
	local e = refs[key]
	if not e then
		e = world:entity() :: Tag
		refs[key] = e
	end
	-- Cannot cache handles because they will get invalidated
	return e, fini(key)
end

local function specific_set(key, id): Tag
	if not key then
		return world:entity()
	end
	if refs[key] ~= nil then
		return refs[key]
	end

	refs[key] = id
	return id
end

local function contains(key)
	return refs[key] ~= nil
end

local ref = setmetatable({
	contains = contains,
	set = specific_set,
}, {
	__call = function(_, key)
		return set(key)
	end,
})

return ref
