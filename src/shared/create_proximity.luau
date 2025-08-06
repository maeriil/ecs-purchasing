local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(ReplicatedStorage.Shared.world)
local c = require(ReplicatedStorage.Shared.components)

type Props = {
	action_text: string,
	offset: Vector2?,
	keyboard_key: Enum.KeyCode?,
	gamepad_key: Enum.KeyCode?,
	parent: BasePart,
	parent_id: jecs.Entity,
	id: jecs.Entity?,
	additional_tags: { string }?,
}

return function(props: Props)
	local pair = jecs.pair

	local e = props.id or world:entity()
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = props.action_text
	prompt.UIOffset = props.offset or Vector2.zero
	prompt.ClickablePrompt = true
	prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
	prompt.KeyboardKeyCode = props.keyboard_key or Enum.KeyCode.E
	prompt.GamepadKeyCode = props.gamepad_key or Enum.KeyCode.ButtonX
	prompt.RequiresLineOfSight = false

	if props.additional_tags then
		for _, tag in props.additional_tags do
			prompt:AddTag(tag)
		end
	end

	prompt.Parent = props.parent

	world:set(e, c.ProximityPrompt, prompt)
	world:add(e, pair(c.EventOf, props.parent_id))
end
