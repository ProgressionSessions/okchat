--[[

  _                                               _____         _ _       _                __      _____  
 | |                                             / ____|       (_) |     | |               \ \    / /__ \ 
 | |     __ _ _ __   __ _ _   _  __ _  __ _  ___| (_____      ___| |_ ___| |__   ___ _ __   \ \  / /   ) |
 | |    / _` | '_ \ / _` | | | |/ _` |/ _` |/ _ \\___ \ \ /\ / / | __/ __| '_ \ / _ \ '__|   \ \/ /   / / 
 | |___| (_| | | | | (_| | |_| | (_| | (_| |  __/____) \ V  V /| | || (__| | | |  __/ |       \  /   / /_ 
 |______\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___|_____/ \_/\_/ |_|\__\___|_| |_|\___|_|        \/   |____|
                     __/ |             __/ |                                                              
                    |___/             |___/                                                               
                    
 This ProgressionChat Plugin allow's you to translate your messages in real time to any language you desire
 WARNING: This plugin must be placed in the automatic plugin loader found in your ProgressionChat settings table, otherwise it will not function.
 Written by ProgressionSessions
 Date: January 29, 2025
 Open sourced to help new developers get a feel for using/creating plugins, please do not redistribute this plugin as your own.

]]

local Plugin = {}

Plugin.meta = {
	Name = "LanguageSwitcherV2",
	Author = "@ProgressionSessions",
	Description = "Allows you to send chats in a language of your choice in real time",
	Thumbnail_URL = "change me at some point",
	Updated = "January 20, 2025"
}

function Plugin.onLoad()
	
	-- >> Enviroment
	
	local ProgressionChat = _G.ProgressionChat
	local Plugin_ENV = ProgressionChat.Plugins
	local Functions = Plugin_ENV.Functions
	local Hooks = Plugin_ENV.Hooks
	local Channel = _G.ProgressionChat_Configuration.Channel
	
	-- >> Modules
	
	local Translator = loadstring(game:HttpGet("https://cdn.progressionsoftworks.dev/scripts/chat/plugin_deps/Translator.lua"))()
	local ISO_Codes = loadstring(game:HttpGet("https://cdn.progressionsoftworks.dev/scripts/chat/plugin_deps/ISOCodes.lua"))()
	print(ISO_Codes)
	
	-- >> Variables
	
	local Current_Language = "en"
	local Sending_Enabled = false
	
	-- >> Handle Plugin Values
	
	Plugin_ENV.disableChatSend = true
	
	-- >> Handle Message Translation
	
	local function translate_message(message,target_iso)
		local response
		local lang
		local success,err = pcall(function()
			local resp1 = Translator:Translate(message,target_iso)
			response = resp1[1]
			lang = resp1[2]
		end)
		if success then
			return response
		elseif err then
			warn("ERROR Translating Message: ",err)
			return nil
		end
	end
	
	-- >> Find ISO
	
	local function iso_code_exist(code) 
		local exist=false
		local ISOcode=nil
		for i,v in pairs(ISO_Codes) do
			--print(v)
			if ( tostring(v):lower():match(tostring(code):lower())~=nil ) then
				exist=true
				ISOcode=v
			end
		end
		return exist,ISOcode
	end
	
	-- >> Handle Chats
	
	local function handle_message(Message) 
		if Message == ">d" then
			Sending_Enabled = false
			Functions.systemMessage("[ LanguageSwitcher ]","Automatic Translation Disabled",Color3.fromRGB(170, 85, 255))
		elseif Message:sub(1,1) == ">" and not Message:find(" ") then
			local found,code = iso_code_exist(tostring(Message:sub(2)))
			if found then
				Sending_Enabled = true
				Current_Language = code
				Functions.systemMessage("[ LanguageSwitcher ]","Successfully set language to "..Current_Language,Color3.fromRGB(170, 85, 255))
			else
				Functions.systemMessage("[ LanguageSwitcher ]","Language ISO Code not found",Color3.fromRGB(255, 0, 0))
			end
		elseif Sending_Enabled and not (Message:sub(1,3) == "/e " or Message:sub(1,7) == "/emote ") then
			local og = Message
			if (Current_Language==nil) then
				Functions.systemMessage("[ LanguageSwitcher ]","Please select a language before sending, or type >d to stop automatic translation.",Color3.fromRGB(255, 0, 0))
			else
			    local NewMessage = translate_message(Message, Current_Language)
			    Channel:SendAsync(NewMessage)
			end
		else
			Channel:SendAsync(Message)
		end
	end
	
	Hooks.bindToCallback("onMessageSent",handle_message)
	
	-- >> Message
	
	Functions.systemMessage("[ LanguageSwitcher ]","Successfully loaded, enjoy!",Color3.fromRGB(170, 85, 255))
	
end

return Plugin