local Plugin = {}

Plugin.meta = {
	Name = "FTAPTyper",
	Author = "@ProgressionSessions",
	Description = "For Myself, for fling things and people. fixes the keyboard type anim",
	Thumbnail_URL = "1009029290303402342",
	Updated = "January 2, 2026"
}

function Plugin.onLoad()

	-- >> Enviroment

	local ProgressionChat = _G.ProgressionChat
	local Plugin_ENV = ProgressionChat.Plugins
	local Functions = Plugin_ENV.Functions
	local Hooks = Plugin_ENV.Hooks

	local TypeEvent = game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild("ChatTyping")
	local Stop = "end"
	local Start = "begin"
	
	local TextBox:TextBox = Functions.getTextbox()

	-- >> Handler

	if (TextBox~=nil) then
		TextBox.Focused:Connect(function()
			TypeEvent:FireServer(Start)
		end)
		TextBox.FocusLost:Connect(function()
			TypeEvent:FireServer(Stop)
		end)
	end

end

return Plugin
