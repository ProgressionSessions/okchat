local run_service = game:GetService("RunService")
local request_function = request or http_request or (syn and syn.request) or (getgenv and getgenv().http and getgenv().http.request) or nil
return function(url)
		if run_service:IsStudio() then
			local remote_function = game.ReplicatedStorage:FindFirstChild("PC_invoke_request")
			if (remote_function) then
				local data = remote_function:InvokeServer("GET",url,false)
				if (data~=nil) then
					local decoded = game:GetService("HttpService"):JSONDecode(data)
					if (decoded~=nil) then
						return decoded
					else
						warn"Json failed to parse"
					end
				else
					warn"Data returned was nil."
					return nil
				end
			else
				warn("Progression Chat Warning: Cannot get json data cause the remotefunction is missing, please add a remote function in 'replicatedstorage' named 'PC_invoke_request'. for more information, visit https://docs.progressionsoftworks.dev/chat/plugins/requirements#requests")
				return nil
			end
		else
			local resp = request_function({
				Url = url,
				Method = 'GET'
			})
			if (resp.StatusCode==200) then
				local decoded = game:GetService("HttpService"):JSONDecode(resp.Body)
				if (decoded~=nil) then
					return decoded
				else
					warn"Json failed to parse"
				end
			else
				warn("Unable to fetch json from url: ",url,", Got status code: ",resp.StatusCode)
			end
		end
	end