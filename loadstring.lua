-- Progression Chat
-- Production Release 2
-- The best roblox chat bar script

_G.ProgressionChat_Configuration = {
	Custom_Tag = {
		enabled=false,
		text="your custom tag here.",
		color=Color3.fromRGB(0, 0, 255)
	},
	Channel = game.TextChatService.TextChannels.RBXGeneral, -- dont fuck with this unless you know what to do with this
	Message_Tween_1 = TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), -- transparency
	Message_Tween_2 = TweenInfo.new(.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out), -- size
	Plugins = { -- OPTIONAL: Allows you to load plugins by list AUTOMATICALY when ProgressionChat loads, Alternatively you can just run the loadstring of your plugins and it will work fine.
		-- paste urls like this: "https://raw.paste.com/scriptid.lua"
		-- You can also paste paths to modules, this is for if you are making a plugin of your own using studio, this makes it easier to test the plugin. (WILL ONLY WORK ON STUDIO)
		},
	ShowTranslatedMessageDefault=true,-- show translated messages by default
	Default_Language="en", -- your default language
	Hook_Chat_Toggle=false, -- toggle weather progressionchat will hide / unhide when :SetCoreGuiEnabled("Chat") is invoked. (REQUIRES HOOKFUNCTION)
	Show_Start_Messages=true, -- if true, system messages showinjg that progression chat has loaded and other info will be shown on startup.
	Debugging = false, -- reccomended to be disabled unless you are using this in a studio enviroment for designing your own plugins.
}

loadstring(game:HttpGet("https://cdn.progressionsoftworks.dev/scripts/chat/script.lua"))()