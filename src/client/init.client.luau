local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local _jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(ReplicatedStorage.Shared.world)
local _c = require(ReplicatedStorage.Shared.components)

local systems = {} :: { (number) -> () }
for _, content in script.systems:GetDescendants() do
	assert(content:IsA("ModuleScript"))

	local status, sys = pcall(require, content)
	assert(status)

	local run_every_frame = sys(world)
	if typeof(run_every_frame) == "function" then
		table.insert(systems, run_every_frame)
	end
end

RunService.Heartbeat:Connect(function(dt)
	for _, system in systems do
		system(dt)
	end
end)
