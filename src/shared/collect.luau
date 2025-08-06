local function collect(signal)
	local enqueued = {}

	local i = 0

	local connection: RBXScriptConnection = signal:Connect(function(...)
		table.insert(enqueued, { ... })
		i += 1
	end)

	local function collection()
		local n = 0
		return function(): any
			if i == 0 then
				return
			end
			n += 1
			i -= 1

			local args: any = table.remove(enqueued, 1)

			return n, unpack(args)
		end
	end

	local function cleanup()
		if connection then
			connection:Disconnect()
		end
	end

	return collection, cleanup
end

type Signal<T... = ...any> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
	ConnectParallel: (self: Signal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
	Once: (self: Signal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
	Wait: (self: Signal<T...>) -> T...,
}

return collect :: <T...>(Signal<T...>) -> (() -> () -> (number, T...), () -> () -> ())
