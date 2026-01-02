
--[[

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 ________  ________  ________  ________  ________  _______   ________   ________  ___  ________  ________   ________  ___  ___  ________  _________   
|\   __  \|\   __  \|\   __  \|\   ____\|\   __  \|\  ___ \ |\   ____\ |\   ____\|\  \|\   __  \|\   ___  \|\   ____\|\  \|\  \|\   __  \|\___   ___\ 
\ \  \|\  \ \  \|\  \ \  \|\  \ \  \___|\ \  \|\  \ \   __/|\ \  \___|_\ \  \___|\ \  \ \  \|\  \ \  \\ \  \ \  \___|\ \  \\\  \ \  \|\  \|___ \  \_| 
 \ \   ____\ \   _  _\ \  \\\  \ \  \  __\ \   _  _\ \  \_|/_\ \_____  \\ \_____  \ \  \ \  \\\  \ \  \\ \  \ \  \    \ \   __  \ \   __  \   \ \  \  
  \ \  \___|\ \  \\  \\ \  \\\  \ \  \|\  \ \  \\  \\ \  \_|\ \|____|\  \\|____|\  \ \  \ \  \\\  \ \  \\ \  \ \  \____\ \  \ \  \ \  \ \  \   \ \  \ 
   \ \__\    \ \__\\ _\\ \_______\ \_______\ \__\\ _\\ \_______\____\_\  \ ____\_\  \ \__\ \_______\ \__\\ \__\ \_______\ \__\ \__\ \__\ \__\   \ \__\
    \|__|     \|__|\|__|\|_______|\|_______|\|__|\|__|\|_______|\_________\\_________\|__|\|_______|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|
                                                               \|_________\|_________|                                                                
                                                                                                                                                
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ProgressionChat V2 Production 
A highly customizable chat system for Roblox featuring custom plugins, themes & more.

@authors ProgressionSessions, VannahCodes (Hookfunction features only)
@release Production
@date 2025/01/29
@ownership Progression Softworks

This script is free to use, modify, and distribute with the exeption of credit towards progression softworks. However, distributing malicious, falsified builds, or builds claiming to be the origin of our chat system will be met with a takedown notice following according legal action(s).
All that we ask is if you decide to redistribute our chat system, atleast give us credit, at the least maybe a message telling the end user that we made the chat system originally.

Please do not edit any of the code below without the proper knowledge of LuaU Programming language, we are nto responsible if you cause any issues via editing the code incorrectly.

Lastly, please if you can, feel free to support us by making a donation, we are giving you this amazing chat system for completly free whilst also needing to pay for script hosting & more, and unfortunately i cant afford to
keep this project alive on my own. so all i ask is specially if you are gonna redistribute our chat system, please help us support this project and continue to add features and make this the most advanced chat system on roblox.
thank you very much for your time, if you re looking to support this project, you can donate from the url(s) below:
    
- PayPal: @ProgressionSessions (Send as friends & family otherwise my account will be locked) 
- Robux: dm @ProgressionSessions on discord

]]--

local Succ,Err = pcall(function()

	local chat = {}

	_G.ProgressionChat = {
		StatusUpdate = nil,
		Destroy=nil,
		onDestroy=nil,
	}

	local connections={}

	local VER = "V02.00.01"

	local debugging_mode = _G.ProgressionChat_Configuration.Debugging or false

	_G.ProgressionChat.Version = VER
	_G.ProgressionChat.Loaded = false
	_G.ProgressionChat.Settings = _G.ProgressionChat_Configuration 
	_G.ProgressionChat.Plugins = {
		interceptIncomingMessages=false,
		disableChatSend=false,
	}

	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local ceil			=math.ceil
	local cf			=CFrame.new
	local v3			=Vector3.new
	local color			=Color3.new
	local dot			=Vector3.new().Dot
	local workspace		=workspace
	local ray			=Ray.new
	local new			=Instance.new
	local rtype			=game.IsA
	local debris		=game.Debris
	local sub			=string.sub
	local len			=string.len
	local lower			=string.lower
	local find			=string.find
	local insert		=table.insert

	local player_service=game:GetService("Players")
	local player	    =player_service.LocalPlayer
	local tweenService  =game:GetService("TweenService")
	local run_service  = game:GetService("RunService")
	local gui_service  = game:GetService("StarterGui")
	gui_service:SetCoreGuiEnabled("Chat",false)
	local mouse =        player:GetMouse()
	local pgui		    =player.PlayerGui

	local userChatIncoming=false
	local chatgui		= game:GetService("RunService"):IsStudio() and script.Parent:WaitForChild("ProgressionChatGUI") or game:GetObjects("rbxassetid://139681537547530")[1]
	chatgui.Enabled=false
	local chatbox		=chatgui:WaitForChild("TextBox")
	local warn			=chatgui:WaitForChild("Warn")
	local assets        =chatgui:WaitForChild("Assets")
	local msg           =assets:WaitForChild("DisplayChatLine")

	local dPrnt = function(...)
		if (debugging_mode==true) then
			print(...)
		end
	end

	local functions = {}
	local request_function = request or http_request or (syn and syn.request) or (getgenv and getgenv().http and getgenv().http.request) or nil

	local globalchat	=chatgui:WaitForChild("ContainerChat")
	local canchat		=true
	local chatspam		=0
	local totalspam		=0
	local maxchar		=200
	local lines			=8
	local chatting
	local scrollingFromBottom = true

	local tester = true

	-- commands 

	local prefix = ">"
	local commands = {}

	local commandFunctions = {}

	function commandFunctions.get_all_commands()
		return commands
	end

	function commandFunctions.create_command(data)
		commands[#commands+1] = data
	end

	function commandFunctions.message_is_command(message)
		if (message:sub(1,1)==prefix) then
			for i,v in pairs(commands) do
				if (message:sub(2,message:len()):lower():match(v.command:lower())~=nil) then
					return v
				end
			end
			return false
		else
			return false
		end
	end

	_G.ProgressionChat.Commands = {}
	_G.ProgressionChat.Commands.Prefix = prefix
	_G.ProgressionChat.Commands.Functions = commandFunctions


	-- create loader

	local progression_chat_loader = Instance.new("ScreenGui")
	progression_chat_loader.IgnoreGuiInset = true
	progression_chat_loader.ResetOnSpawn = false
	progression_chat_loader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	progression_chat_loader.Name = "ProgressionChat Loader"
	progression_chat_loader.Parent = game.Players.LocalPlayer.PlayerGui

	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BorderColor3 = Color3.new(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Position = UDim2.new(0.5, 0, 0.0250000004, 0)
	frame.Size = UDim2.new(0, 0, 0, 39)
	frame.Visible = true
	frame.Parent = progression_chat_loader

	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(100, 100)
	uicorner.Parent = frame

	local uistroke = Instance.new("UIStroke")
	uistroke.Color = Color3.new(0.27451, 0.27451, 0.27451)
	uistroke.Thickness = 2
	uistroke.Parent = frame

	local holder = Instance.new("Frame")
	holder.AnchorPoint = Vector2.new(0.5, 0.5)
	holder.AutomaticSize = Enum.AutomaticSize.X
	holder.BackgroundColor3 = Color3.new(1, 1, 1)
	holder.BackgroundTransparency = 1
	holder.BorderColor3 = Color3.new(0, 0, 0)
	holder.BorderSizePixel = 0
	holder.Position = UDim2.new(0.5, 0, 0.5, 0)
	holder.Size = UDim2.new(0, 0, 1, 0)
	holder.Visible = true
	holder.Name = "Holder"
	holder.Parent = frame

	local image_label = Instance.new("ImageLabel")
	image_label.Image = "rbxassetid://122813401889227"
	image_label.ImageTransparency = 1
	image_label.ScaleType = Enum.ScaleType.Crop
	image_label.BackgroundColor3 = Color3.new(1, 1, 1)
	image_label.BackgroundTransparency = 1
	image_label.BorderColor3 = Color3.new(0, 0, 0)
	image_label.BorderSizePixel = 0
	image_label.Size = UDim2.new(0, 20, 0, 20)
	image_label.Visible = true
	image_label.Parent = holder

	local text_label = Instance.new("TextLabel")
	text_label.FontFace = Font.fromId(12187365364,Enum.FontWeight.Regular,Enum.FontStyle.Normal)
	text_label.RichText = true
	text_label.Text = '<b>ProgressionChat</b><font color="rgb(163, 163, 163)"> By Progression Softworks</font>'
	text_label.TextColor3 = Color3.new(1, 1, 1)
	text_label.TextSize = 14
	text_label.TextXAlignment = Enum.TextXAlignment.Left
	text_label.AutomaticSize = Enum.AutomaticSize.X
	text_label.BackgroundColor3 = Color3.new(1, 1, 1)
	text_label.BackgroundTransparency = 1
	text_label.BorderColor3 = Color3.new(0, 0, 0)
	text_label.BorderSizePixel = 0
	text_label.Position = UDim2.new(0.204819277, 0, 0.269230783, 0)
	text_label.Size = UDim2.new(0, 0, 0, 28)
	text_label.Visible = true
	text_label.Parent = holder
	text_label.TextTransparency=1

	local uilist_layout = Instance.new("UIListLayout")
	uilist_layout.Padding = UDim.new(0, 8)
	uilist_layout.FillDirection = Enum.FillDirection.Horizontal
	uilist_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uilist_layout.SortOrder = Enum.SortOrder.LayoutOrder
	uilist_layout.VerticalAlignment = Enum.VerticalAlignment.Center
	uilist_layout.Parent = holder

	-- visualize it.

	tweenService:Create(text_label,TweenInfo.new(.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
		TextTransparency=0
	}):Play()
	tweenService:Create(image_label,TweenInfo.new(.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
		ImageTransparency=0
	}):Play()
	tweenService:Create(frame,TweenInfo.new(.45,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
		Size = UDim2.new(0, holder.AbsoluteSize.X + 60,0, 39)
	}):Play()

	local loaderResizeConnection = holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		tweenService:Create(frame,TweenInfo.new(.765,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
			Size = UDim2.new(0, holder.AbsoluteSize.X + 60,0, 39)
		}):Play()
	end)

	local doSpin=false
	--local elapseTime=0

	local loaderIconSpinConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
		--elapseTime += dt
		--if elapseTime >= 5 then
		--elapseTime = 0
		if doSpin then
			if image_label.Rotation >= 360 then
				image_label.Rotation=0
			end
			image_label.Rotation = image_label.Rotation + 1
		else
			image_label.Rotation=0
		end
		--end
	end)

	task.wait(1)

	text_label.Text = 'Importing Remote assets'
	image_label.Image = "rbxassetid://17794067799"

	-- import

	local fetchJson = run_service:IsStudio() and loadstring(game:HttpGet('https://cdn.progressionsoftworks.dev/scripts/chat/dependencies/load_json.lua'))() or require(script:WaitForChild("fetchJson"))

	local developer_database = fetchJson("https://cdn.progressionsoftworks.dev/scripts/chat/json/developers.json")
	local internal_themes = fetchJson("https://cdn.progressionsoftworks.dev/scripts/chat/json/themes.json")

	task.wait(.23)

	text_label.Text = 'Assembling <b><font color="rgb(85, 85, 255)">ToolTip Module</font></b>'
	image_label.Image = "rbxassetid://17794067799"

	local tooltip_module = {}

	local tooltiplabel = chatgui:WaitForChild("tooltip")

	local tooltipConnection = nil

	function tooltip_module.show(text,doTween)
		tooltiplabel.Visible=true
		tooltiplabel.Text = tostring(text)
		coroutine.wrap(function()
			tooltipConnection = run_service.RenderStepped:Connect(function()
				tooltiplabel.Position = UDim2.fromOffset(mouse.X, mouse.Y)
			end)
		end)()
		if doTween then
			tweenService:Create(tooltiplabel,_G.ProgressionChat_Configuration["Message_Tween_1"],{
				BackgroundTransparency=0.3,
				TextTransparency=0
			}):Play()
		else
			tooltiplabel.BackgroundTransparency=0.3
			tooltiplabel.TextTransparency=0
		end
	end

	function tooltip_module.hide(doTween)
		if (tooltipConnection~=nil) then
			tooltipConnection:Disconnect()
			tooltipConnection=nil
		end
		if doTween then
			tweenService:Create(tooltiplabel,_G.ProgressionChat_Configuration["Message_Tween_1"],{
				BackgroundTransparency=1,
				TextTransparency=1
			}):Play()
		else
			tooltiplabel.BackgroundTransparency=1
			tooltiplabel.TextTransparency=1
		end
	end

	_G.ProgressionChat.Tooltips = tooltip_module

	task.wait(.124)

	text_label.Text = 'Assembling <b><font color="rgb(85, 85, 255)">Functions</font></b>'
	image_label.Image = "rbxassetid://17794067799"
	doSpin=true

	local function check_if_developer(userid)
		if (developer_database) then
			dPrnt(userid)
			dPrnt(developer_database[1])
			if (table.find(developer_database,userid)~=nil) then
				dPrnt("dev found")
				return true
			else
				dPrnt("nodev 2")
				return false
			end
		else
			dPrnt("nodev 1")
			return false
		end
	end

	function functions.findPlayerV1(name, speaker)
		if lower(name) == "all" then
			local chars = {}
			local c = game:GetService("Players"):GetPlayers()
			for i = 1, #c do
				insert(chars, c[i])
			end
			return chars
		elseif lower(name) == "me" then
			return {speaker}
		elseif lower(name) == "others" then
			local chars = {}
			local c = game:GetService("Players"):GetPlayers()
			for i = 1, #c do
				if c ~= speaker then
					insert(chars, c[i])
				end
			end
			return chars
		else
			local chars = {}
			local commalist = {}
			local ssn = 0
			local lownum = 1
			local highestnum = 1
			local foundone
			while true do
				ssn = ssn + 1
				if sub(name, ssn, ssn) == "" then
					insert(commalist, lownum)
					insert(commalist, ssn - 1)
					highestnum = ssn - 1
					break
				end
				if string.sub(name, ssn, ssn) == "," then
					foundone = true
					table.insert(commalist, lownum)
					table.insert(commalist, ssn)
					lownum = ssn + 1
				end
			end
			if foundone then
				for ack = 1, #commalist, 2 do
					local cnum = 0
					local char
					local c = game:GetService("Players"):GetPlayers()
					for i = 1, #c do
						if find(lower(c[i].Name), sub(lower(name), commalist[ack], commalist[ack + 1] - 1)) == 1 then
							char = c[i]
							cnum = cnum + 1
						end
					end
					if cnum == 1 then
						table.insert(chars, char)
					end
				end
				return #chars ~= 0 and chars or 0
			else
				local cnum = 0
				local char
				local c = game:GetService("Players"):GetPlayers()
				for i = 1, #c do
					if find(lower(c[i].Name), lower(name)) == 1 then
						char = {
							c[i]
						}
						cnum = cnum + 1
					end
				end
				return cnum == 1 and char or 0
			end
		end
	end

	function functions.getTagColorFormat(color3)

	end

	function functions.getChatColor(user)
		local NAME_COLORS =
			{
				Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
				Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
				Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
				BrickColor.new("Bright violet").Color,
				BrickColor.new("Bright orange").Color,
				BrickColor.new("Bright yellow").Color,
				BrickColor.new("Light reddish violet").Color,
				BrickColor.new("Brick yellow").Color,
			}

		local function GetNameValue(pName)
			local value = 0
			for index = 1, #pName do
				local cValue = string.byte(string.sub(pName, index, index))
				local reverseIndex = #pName - index + 1
				if #pName%2 == 1 then
					reverseIndex = reverseIndex - 1
				end
				if reverseIndex%4 >= 2 then
					cValue = -cValue
				end
				value = value + cValue
			end
			return value
		end

		local color_offset = 0

		return NAME_COLORS[((GetNameValue(user) + color_offset) % #NAME_COLORS) + 1]



	end

	function functions.formatChatColor(Color)
		return string.format('rgb(%s,%s,%s)',math.round(Color.R*255),math.round(Color.G*255),math.round(Color.B*255))
	end

	function functions.createChat(data)

		local sender = data.sender
		local message = data.message
		local tagData = data.tag
		local translationData = data.translation
		local privateChatData = data.privateChat
		local developer = data.isDeveloper

		local messageTimeStamp = data.messageTimeStamp

		local newChat = msg:Clone()
		newChat.Name = sender.Name.."_MESSAGE"..tostring(math.random(1,900000))

		local function updateText(m)
			if (privateChatData.isPrivateChat==true) then
				if (tagData.hasTag) then
					newChat:WaitForChild("TextContent").Text = string.format('<font color="%s">%s (@%s): </font>[FROM %s (@%s)] %s',functions.formatChatColor(functions.getChatColor(sender.Name)),sender.DisplayName,sender.Name,privateChatData.privateChatSender.DisplayName,privateChatData.privateChatSender.Name,m)
				else
					newChat:WaitForChild("TextContent").Text = string.format('<font color="%s">%s</font> | <font color="%s">%s (@%s): </font>[FROM %s (@%s)] %s',functions.formatChatColor(tagData.color),tagData.text,functions.formatChatColor(functions.getChatColor(sender.Name)),sender.DisplayName,sender.Name,privateChatData.privateChatSender.DisplayName,privateChatData.privateChatSender.Name,m)
				end
			else
				if (tagData.hasTag) then
					newChat:WaitForChild("TextContent").Text = string.format('<font color="%s">%s (@%s): </font>%s',functions.formatChatColor(functions.getChatColor(sender.Name)),sender.DisplayName,sender.Name,m)
				else
					newChat:WaitForChild("TextContent").Text = string.format('<font color="%s">%s</font> | <font color="%s">%s (@%s): </font>%s',functions.formatChatColor(tagData.color),tagData.text,functions.formatChatColor(functions.getChatColor(sender.Name)),sender.DisplayName,sender.Name,m)
				end
			end
		end
		task.spawn(updateText,message)
		local s1,e1 =	pcall(function()
			if (messageTimeStamp['timestampInstance']~=nil) then
				local TSI = messageTimeStamp['timestampInstance']
				if messageTimeStamp["timeZone"]:lower() == "local"  then
					newChat.TextTimestamp.Text = TSI:FormatLocalTime("hh","en-us")..":"..TSI:FormatLocalTime("mm","en-us").." "..TSI:FormatLocalTime("A","en-us")
				elseif  messageTimeStamp["timeZone"]:lower() == "universal"  then
					newChat.TextTimestamp.Text = TSI:FormatUniversalTime("hh","en-us")..":"..TSI:FormatUniversalTime("mm","en-us").." "..TSI:FormatUniversalTime("A","en-us")
				end
			end
		end)
		if e1 then print("Unable to format timestamp: ",e1) end

		-- translation features

		local showingTranslated = false

		if (translationData.messageTranslated==true) or (debugging_mode==true) then
			newChat.TextTimestamp.Position = UDim2.new(0, 20,0.5, 0)
			newChat.TextContent.Position = UDim2.new(0, 75,0.5, 0)
			newChat.translateButton.Visible=true
			local button = newChat.translateButton
			local isHovering = false

			connections["TranslateButton_"..newChat.Name.."_Press"]=	button.MouseButton1Down:Connect(function()
				if showingTranslated then
					showingTranslated=false
					updateText(message)
					if (isHovering==true) then
						tooltip_module.show("Tap this button to see the translated version of this message, automatically translated to your set language.",true)
					end
					newChat.translateButton.Image = "rbxasset://textures/translateIcon.png"
					newChat.translateButton.HoverImage = "rbxasset://textures/translateIconDark.png"
				else
					showingTranslated=true
					updateText(translationData.translatedMessage)
					if (isHovering==true) then
						tooltip_module.show("Tap this button to see the original & untranslated version of this message, in its origin language.",true)
					end
					newChat.translateButton.HoverImage = "rbxasset://textures/translateIcon.png"
					newChat.translateButton.Image = "rbxasset://textures/translateIconDark.png"
				end
			end)

			connections["TranslateButton_"..newChat.Name.."_Enter"]=	button.MouseEnter:Connect(function()
				dPrnt("hovered")
				isHovering=true
				if (showingTranslated==true) then
					tooltip_module.show("Tap this button to see the translated version of this message, automatically translated to your set language.",true)
				else
					tooltip_module.show("Tap this button to see the original & untranslated version of this message, in its origin language.",true)
				end
			end)
			connections["TranslateButton_"..newChat.Name.."_Leave"]=	button.MouseLeave:Connect(function()
				dPrnt("hoveredLost")
				isHovering=false
				tooltip_module.hide(true)
			end)

		end

		if (developer==true) then
			dPrnt('IS DEVELOPER')
			local button = newChat.developer_icon_holder.icon
			button.Parent.Visible=true

			connections["devIcon_"..newChat.Name.."_Enter"]=	button.MouseEnter:Connect(function()
				tooltip_module.show("Special icon given only to developers/contributors of ProgressionChat, if you see this badge in game make sure to tell us how you feel about progressionchat!",true)
			end)
			connections["devIcon_"..newChat.Name.."_Leave"]=	button.MouseLeave:Connect(function()
				tooltip_module.hide(true)
			end)

		end

		if (debugging_mode==true) then
			newChat.translateButton.Visible=true -- always show on testing
		end

		-- render the text

		newChat.TextContent.TextTransparency=1
		newChat.TextTimestamp.TextTransparency=1
		newChat.translateButton.ImageTransparency=1
		newChat.Size = UDim2.new(1,0,0,0)

		newChat.Parent=globalchat

		-- tweens

		tweenService:Create(newChat.TextContent,_G.ProgressionChat_Configuration["Message_Tween_1"],{
			TextTransparency=0
		}):Play()
		tweenService:Create(newChat.TextTimestamp,_G.ProgressionChat_Configuration["Message_Tween_1"],{
			TextTransparency=0
		}):Play()
		tweenService:Create(newChat.translateButton,_G.ProgressionChat_Configuration["Message_Tween_1"],{
			ImageTransparency=0
		}):Play()
		tweenService:Create(newChat,_G.ProgressionChat_Configuration["Message_Tween_2"],{
			Size=UDim2.new(1,0,0,21)
		}):Play()


	end

	function functions.systemMessage(t,m,c,r)
		local newChat = msg:Clone()
		newChat.Name = "SYSTEM_MESSAGE"..tostring(math.random(1,900000))


		-- set the text 

		if (r==true) then
			newChat.TextContent.RichText = true
		end

		newChat.TextContent.TextColor3 = c
		if (t~=nil) then
			newChat.TextContent.Text = t.." | "..m
		else
			newChat.TextContent.Text = m
		end

		-- render the text

		newChat.TextContent.TextTransparency=1
		newChat.TextTimestamp.TextTransparency=1
		newChat.translateButton.ImageTransparency=1
		newChat.Size = UDim2.new(1,0,0,0)

		newChat.Parent=globalchat

		-- tweens

		tweenService:Create(newChat.TextContent,_G.ProgressionChat_Configuration["Message_Tween_1"],{
			TextTransparency=0
		}):Play()
		tweenService:Create(newChat.TextTimestamp,_G.ProgressionChat_Configuration["Message_Tween_1"],{
			TextTransparency=0
		}):Play()
		tweenService:Create(newChat.translateButton,_G.ProgressionChat_Configuration["Message_Tween_1"],{
			ImageTransparency=0
		}):Play()
		local text_height = newChat.TextContent.AbsoluteSize.Y
		dPrnt(text_height)
		if (text_height>=30) then
			tweenService:Create(newChat,_G.ProgressionChat_Configuration["Message_Tween_2"],{
				Size=UDim2.new(1,0,0,text_height)
			}):Play()
		else
			tweenService:Create(newChat,_G.ProgressionChat_Configuration["Message_Tween_2"],{
				Size=UDim2.new(1,0,0,21)
			}):Play()
		end
	end

	function functions.getTextbox()
		return chatbox
	end

	function functions.checkPrivateChat(sender,reciever,message)
		return nil
	end

	function functions.playerChat(mesData)
		local textSource = mesData.TextSource
		local senderID = textSource.UserId
		local timeStamp = mesData.Timestamp
		local text = mesData.Text
		local translatedText = mesData.Translation
		local metadata = mesData.Metadata


		local player = game:GetService("Players"):FindFirstChild(tostring(textSource.Name))

		local tagSettings = _G.ProgressionChat_Configuration["Custom_Tag"]

		local isTranslated  =false

		if (translatedText~=(nil or "")) then
			isTranslated=true
		end

		local isPrivateChat = false

		local privateChatData = functions.checkPrivateChat(textSource,game:GetService("Players")["LocalPlayer"],text)

		if (privateChatData~=nil) then
			isPrivateChat = true
		end

		if player==game:GetService("Players").LocalPlayer and (debugging_mode) then
			userChatIncoming=true
		end

		local tagData

		if (tagSettings~=nil) then
			if player.UserId == game:GetService("Players").LocalPlayer.UserId then
				tagData = {hasTag=(tagSettings.enabled==true),text=tagSettings.text,color=tagSettings.color}
			else
				tagData = {hasTag=false,text="",color=Color3.fromRGB(255, 255, 255)}
			end
		else
			tagData = {hasTag=false,text="",color=Color3.fromRGB(255, 255, 255)}
		end

		if player then
			local chatData = {
				sender = player,
				message = text,
				tag = tagData,
				translation = {messageTranslated=isTranslated,translatedMessage=translatedText},
				privateChat = {isPrivateChat=isPrivateChat,privateChatSender=privateChatData},
				messageTimeStamp = {timestampInstance=timeStamp,timeZone="local"},
				isDeveloper = check_if_developer(senderID),
				--isFriend = check_if_friend(senderID),
			}

			local cSuccess,cError = pcall(functions.createChat,chatData)
		else
			return warn("Unable to send new chat: Error 054: Player is nil")
		end
	end

	_G.ProgressionChat.Plugins.Functions = functions

	-- create all commands which utilize functions

	commands[#commands+1] = {
		command = "version",
		desc = "Shows you the version of progressionchat that you are currently using.",
		is_plugin_command=false,
		Plugin_Name = nil,
		callback = function(message)
			functions.systemMessage("[ Version ]","You are currently using progressionchat version: "..VER,Color3.fromRGB(85, 255, 127))
		end,
	}
	commands[#commands+1] = {
		command = "discord",
		desc = "Prompts you to join our discord server.",
		is_plugin_command=false,
		Plugin_Name = nil,
		callback = function(message)
			local CurrentDiscordInvite = isfile('Invite.pchat') and readfile('Invite.pchat') or nil
			local Code = "tvrdf6b73f" -- last updated: 01/29/2025
			if request_function then
				local Invite
				local r = request_function(
					{
						['Method'] = 'GET',
						['Headers'] = {
							['discordLinkRequest'] = "true"
						},
						['Url'] = 'https://cdn.progressionsoftworks.dev/raw/discord.txt'
					})
				if r.StatusCode ~= 200 or not r.Successful then
					Invite = Code
				else
					Invite = r.Body
				end
				if not CurrentDiscordInvite or CurrentDiscordInvite ~= Invite then
					request_function(
						{
							['Method'] = 'POST',
							['Headers'] = {
								["origin"] = 'https://discord.com',
								["Content-Type"] = "application/json"
							},
							['Url'] = 'http://127.0.0.1:6463/rpc?v=1',
							['Body'] = game:GetService('HttpService'):JSONEncode({cmd="INVITE_BROWSER",args={code=Invite},nonce=game:GetService('HttpService'):GenerateGUID(false):lower()})
						}    
					)
					writefile('Invite.pchat',Invite)
				end
			else
				functions.systemMessage("[ WARNING ]","Your code ide does not support https requests, the discord link has been copied to your clipboard.",Color3.fromRGB(255, 170, 0))
				setclipboard("discord.gg/"..Code)
			end	
		end,
	}

	task.wait(.5)

	text_label.Text = 'Assembling <b><font color="rgb(85, 85, 255)">Hooks Module</font></b>'
	image_label.Image = "rbxassetid://17794067799"

	local hooks_module = {}

	local hooks = {
		onChatboxFocused={},
		onChatboxFocusLoss={},
		onMessageSent={},
		onMessageRecieved={},
	}

	function hooks_module.bindToCallback(hook,callback)
		if hooks[hook] then
			table.insert(hooks[hook],callback)
		else
			functions.systemMessage("[ WARNING ]","One of your user plugins attempted to bind to a nonexistant hook. if you know what plugin it is, please contact the developer or remove the plugin to prevent further issues. Hook Name: "..hook,Color3.fromRGB(255, 170, 0))
		end
	end
	function hooks_module.invoke(hook,...)
		if hooks[hook] then
			for i=1,#hooks[hook] do
				local callback = hooks[hook][i]
				task.spawn(callback,...)
			end
		else
			warn('INTERNAL ERROR: "',hook,'" Is not a valid hook.')
		end
	end

	hooks_module.hooks = hooks
	_G.ProgressionChat.Plugins.Hooks = hooks_module

	task.wait(.32)

	text_label.Text = 'Hooking <b><font color="rgb(85, 85, 255)">Message Callbacks</font></b>'
	image_label.Image = "rbxassetid://17794067799"

	-- log chat new for tcs

	game:GetService("TextChatService").OnIncomingMessage = function(mesData)
		--local succ1,err1=pcall(function()
		if mesData.Status == Enum.TextChatMessageStatus.Success then

			if mesData.TextSource == nil then
				dPrnt(mesData)
				task.spawn(functions.systemMessage,nil,mesData.Text,Color3.new(1, 1, 1),true)
			else
				if mesData.Text=="Roblox automatically translates supported languages in chat" then
					functions.systemMessage("[ SYSTEM ]",mesData.Text,Color3.fromRGB(0, 170, 255))
					return
				end

				if _G.ProgressionChat.Plugins["interceptIncomingMessages"] then
					hooks_module.invoke("onMessageRecieved",mesData)
				else
					local s1,e1=pcall(function()
						task.spawn(functions.playerChat,mesData)
					end)

					if e1 then print("ERROR MESSAGE RECIEVE: ",e1) end
				end
			end

		end
		--end)
		--if err1 then
		--warn("TCS.OnIncomingMessage ERROR: ",err1)
		--end
	end

	-- log system messages on TCS

	local function newchat()
		dPrnt("Setting Up Chat")
		local Succ,Err = pcall(function()
			local message=chatbox.Text
			local is_command = commandFunctions.message_is_command(message)
			if (is_command~=false) then
				local s6,e6= pcall(function()
					task.spawn(is_command.callback,message)
				end)
				if e6 then
					warn("Unable to run command: ",e6)
				end
				chatbox.Text="Press '/' or click here to chat"
				chatting=false
				chatbox.ClearTextOnFocus=true
			else
				pcall(function()
					coroutine.wrap(function()
						hooks_module.invoke("onMessageSent",message)
					end)()
				end)
				if _G.ProgressionChat.Plugins["disableChatSend"] ~= true then
					userChatIncoming=true
					_G.ProgressionChat.Settings["Channel"]:SendAsync(message)

				end

				chatbox.Text="Press '/' or click here to chat"
				chatting=false
				chatbox.ClearTextOnFocus=true
				dPrnt("MessageSend Success")
			end
		end)
		if Err then
			print("Message Send Failure: ",Err)
		end
	end

	task.wait(.2)

	text_label.Text = 'Assembling <b><font color="rgb(85, 85, 255)">Interface & Connections</font></b>'
	image_label.Image = "rbxassetid://17794067799"

	connections["focused"]=chatbox.Focused:connect(function()

		pcall(function()
			coroutine.wrap(function()
				hooks_module.invoke("onChatboxFocused",chatbox)
			end)()
		end)
		chatbox.Active=true
	end)

	connections["focusLost"]=chatbox.FocusLost:connect(function(enter)
		pcall(function()
			coroutine.wrap(function()
				hooks_module.invoke("onChatboxFocusLoss",chatbox)
			end)()
		end)
		chatbox.Active=false
		if enter and chatbox.Text~="" then
			dPrnt("Sending Message")
			newchat()
			chatbox.Text = "Press '/' or click here to chat"
		end
	end)

	connections["slashBind"]=game:GetService("UserInputService").InputBegan:connect(function(keycode)

		if not canchat then chatbox.Visible=false return end
		if warn.Visible then return end
		local key=keycode.KeyCode
		if key==Enum.KeyCode.Slash and not chatbox.Active then
			dPrnt("Chat key press")
			wait(-math.huge)
			chatbox:CaptureFocus()
			chatbox.ClearTextOnFocus=false
		end
	end)

	connections["cbInt"]=chatbox.Interactive.MouseButton1Down:Connect(function()
		dPrnt("Chat Clicked")
		wait(-math.huge)
		chatbox:CaptureFocus()
		chatbox.ClearTextOnFocus=false
	end)

	local function updateGlobalChat(c)
		local list = globalchat:FindFirstChildWhichIsA("UIListLayout")
		local child_count = #globalchat:GetChildren()
		local subtract_count = 2
		local max_msg_before_scroll=7
		if ((child_count-subtract_count)>=max_msg_before_scroll) then
			scrollingFromBottom=false
			list.VerticalAlignment = Enum.VerticalAlignment.Top
			coroutine.wrap(function()
				for i=1,20 do
					wait()
					globalchat.CanvasPosition =  Vector2.new(0, globalchat.AbsoluteCanvasSize.Y) --Vector2.new(0, globalchat.CanvasSize.Y.Offset - globalchat.AbsoluteSize.Y)
				end
			end)()
		else
			scrollingFromBottom=true
			list.VerticalAlignment = Enum.VerticalAlignment.Bottom
		end
	end

	connections["chat_container_positioner_1"]=globalchat.ChildAdded:Connect(updateGlobalChat)
	connections["chat_container_positioner_2"]=globalchat.ChildRemoved:Connect(updateGlobalChat)

	task.wait(.085)


	chatbox.Text = "Press '/' or click here to chat"
	chatgui.Enabled=true


	coroutine.wrap(function()
		if _G.ProgressionChat_Configuration.Show_Start_Messages==true then
			functions.systemMessage("[ ProgressionChat ]","Successfully loaded, enjoy!",Color3.fromHex("#5555ff"))
			functions.systemMessage("[ ProgressionChat ]","Join the discord to stay updated on changes and announcements for progressionchat! https://discord.progressionsoftworks.dev",Color3.fromHex("#5555ff"))
			functions.systemMessage("[ ProgressionChat ]","Visit https://chat.progressionsoftworks.dev to get plugins, themes, view the update log and much more!",Color3.fromHex("#5555ff"))
		end
	end)()
	local RunService = game:GetService("RunService")
	local CoreGui = game.CoreGui

	if not RunService:IsStudio() then
		if gethui then
			chatgui.Parent = gethui()
		elseif syn.protect_gui then 
			syn.protect_gui(chatgui)
			chatgui.Parent = CoreGui
		elseif CoreGui:FindFirstChild("RobloxGui") then
			chatgui.Parent = CoreGui:FindFirstChild("RobloxGui")
		else
			chatgui.Parent = CoreGui
		end
	else
		chatgui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	end

	-- destroy

	local function destroy()
		for i,v in pairs(connections) do
			dPrnt(v)
			v:Disconnect()
		end
		if (_G.ProgressionChat.onDestroy~=nil) then
			pcall(function()
				coroutine.wrap(function()
					_G.ProgressionChat.onDestroy()
				end)
			end)
		end
		chatgui:Destroy()
		game.StarterGui:SetCoreGuiEnabled("Chat",false)
		print("ProgressionChat has been destroyed.")
	end

	_G.ProgressionChat.Destroy = destroy

	-- uhhhh

	-- let you know about ready!
	pcall(function() _G.ProgressionChat.StatusUpdate("READY") end)


	-- load plugins

	task.wait(.78)

	doSpin=false
	image_label.Image = "rbxassetid://130782276840965"


	local isstudio = RunService:IsStudio()

	if (_G.ProgressionChat_Configuration.Plugins~=nil) then
		dPrnt("Loading Plugins")
		for index,Plugin in pairs(_G.ProgressionChat_Configuration.Plugins) do
			if isstudio then
				local PFile
				local s1,e1 = pcall(function()
					PFile = require(Plugin)
				end)
				text_label.Text = string.format('Downloading Plugin "<b><font color="rgb(85, 85, 255)">%s</font></b>"',PFile.meta.Name)
				if e1 then
					warn("PROGRESSIONCHAT: Plugin: ",PFile.meta.Name," Has failed to load.")
				elseif s1 then
					print("PROGRESSIONCHAT: Successfully loaded plugin: ",PFile.meta.Name)
					if (PFile.onLoad) then
						PFile.onLoad(_G.ProgressionChat)
					end
				end
			else
				local PFile
				local s1,e1 = pcall(function()
					PFile = loadstring(game:HttpGet(Plugin))()
				end)
				text_label.Text = string.format('Downloading Plugin "<b><font color="rgb(85, 85, 255)">%s</font></b>"',PFile.meta.Name)
				if e1 then
					warn("PROGRESSIONCHAT: Plugin: ",PFile.meta.Name," Has failed to load.")
				elseif s1 then
					print("PROGRESSIONCHAT: Successfully loaded plugin: ",PFile.meta.Name)
					if (PFile.onLoad) then
						PFile.onLoad(_G.ProgressionChat)
					end
				end
			end
			task.wait(.035)
		end
	end

	commands[#commands+1] = {
		command = "cmds",
		desc = "shows you all the existing commands.",
		callback = function(message)
			functions.systemMessage("[ Commands ]","Heres a list of all ProgressionChat commands.",Color3.fromRGB(0, 85, 0))
			local plugin_commands = {}
			for i,v in pairs(commands) do
				local cmd = v.command
				local desc = v.desc
				local isPlugin = v["is_plugin_command"]
				if isPlugin then
					table.insert(plugin_commands,v)
				else
					functions.systemMessage("[ "..prefix..cmd.." ]",desc,Color3.fromRGB(0, 255, 255))
				end
			end
			if (#plugin_commands>=1) then
				functions.systemMessage("[ External Commands ]","Heres a list of all External commands, these commands were created by user plugins or external themes.",Color3.fromRGB(0, 85, 0))
				for i,v in pairs(plugin_commands) do
					local cmd = v.command
					local desc = v.desc
					functions.systemMessage("[ "..v.Plugin_Name.." ] [ "..prefix..cmd.." ]",desc,Color3.fromRGB(0, 255, 255))
				end
			end
		end,
	}


	coroutine.wrap(function()
		if _G.ProgressionChat_Configuration.Show_Start_Messages==true then
			functions.systemMessage("[ ProgressionChat ]","Type "..prefix.."cmds in chat to view a list of ProgressionChat's commands.",Color3.fromHex("#5555ff"))
		end
	end)()
	
	task.wait(.1)

	doSpin=true
	text_label.Text = 'Assembling themes module...'
	image_label.Image = "rbxassetid://17794067799"

	task.wait(.5)

	text_label.Text = 'Finishing & Cleaning up'

	-- ensure that the default chat ui cannot return

	local tcs = game:GetService("TextChatService")
	tcs.ChatWindowConfiguration.Enabled=false
	tcs.ChatInputBarConfiguration.Enabled=false
	tcs.ChannelTabsConfiguration.Enabled=false


	-- hookfunc onto the startergui chat toggle

	if (_G.ProgressionChat_Configuration.Hook_Chat_Toggle==true) then
		if (hookfunction) then
			hookfunction(gui_service.SetCoreGuiEnabled, function(core,toggle) 
				if (tostring(core):lower()=="chat") then
					chatgui.Enabled = toggle
				end
			end)
		else
			functions.systemMessage("[ WARNING ]",'Setting "Hook_Chat_Toggle" will not function because your code ide is lacking support for hookfunction, which is required to use this feature.',Color3.fromRGB(255, 170, 0))
		end
	end

	task.wait(.7)

	loaderResizeConnection:Disconnect()
	loaderIconSpinConnection:Disconnect()
	progression_chat_loader:Destroy()


end)
if Err then
	warn("PROGRESSIONCHAT | CRITICAL CHAT ERROR: ",Err)
end
