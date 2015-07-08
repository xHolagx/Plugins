PLUGIN.Title       = "Better Chatname"
PLUGIN.Description = "Change default chatname colors and prefix for groups."
PLUGIN.Author      = "LaserHydra"
PLUGIN.Version     = V(2, 4, 0)
PLUGIN.ResourceId  = 979

function PLUGIN:LoadDefaultConfig()
	self.Config = self.Config or {}
	self.Config.player = self.Config.player or {}
	self.Config.mod = self.Config.mod or {}
	self.Config.owner = self.Config.owner or {}
	
	self.Config.player.Formatting = self.Config.player.Formatting or "{Title} {Name}<color={TextColor}>:</color> {Message}"
	self.Config.player.Permission = self.Config.player.Permission or "color_player"
	self.Config.player.Title = self.Config.player.Prefix or "[Player]"
	self.Config.player.TitleColor = self.Config.player.PrefixColor or "lime"
	self.Config.player.NameColor = self.Config.player.NameColor or "lime"
	self.Config.player.TextColor = self.Config.player.TextColor or "white"
	self.Config.player.Rank = self.Config.player.Rank or 1
	
	self.Config.mod.Formatting = self.Config.mod.Formatting or "{Title} {Name}<color={TextColor}>:</color> {Message}"
	self.Config.mod.Permission = self.Config.mod.Permission or "color_mod"
	self.Config.mod.Title = self.Config.mod.Prefix or "[Mod]"
	self.Config.mod.TitleColor = self.Config.mod.PrefixColor or "yellow"
	self.Config.mod.NameColor = self.Config.mod.NameColor or "lime"
	self.Config.mod.TextColor = self.Config.mod.TextColor or "white"
	self.Config.mod.Rank = self.Config.mod.Rank or 2
	
	self.Config.owner.Formatting = self.Config.owner.Formatting or "{Title} {Name}<color={TextColor}>:</color> {Message}"
	self.Config.owner.Permission = self.Config.owner.Permission or "color_owner"
	self.Config.owner.Title = self.Config.owner.Prefix or "[Owner]"
	self.Config.owner.TitleColor = self.Config.owner.PrefixColor or "orange"
	self.Config.owner.NameColor = self.Config.owner.NameColor or "lime"
	self.Config.owner.TextColor = self.Config.owner.TextColor or "white"
	self.Config.owner.Rank = self.Config.owner.Rank or 3
	
	self:SaveConfig()
end

function PLUGIN:GetPlayerFormatting(player)
	local uid = rust.UserIDFromPlayer(player)
	local playerData = {}
	playerData.GroupRank = 0
	for group, data in pairs(self.Config) do
		if permission.UserHasPermission(uid, data.Permission) then
			if data.Rank > playerData.GroupRank then
				playerData.Formatting = data.Formatting
				playerData.GroupRank = data.Rank
				playerData.Title = data.Title
				playerData.TitleColor = data.TitleColor
				playerData.NameColor = data.NameColor
				playerData.TextColor = data.TextColor
			end
		end
	end
	
	return playerData
end

function PLUGIN:Init()
	ChatMute = plugins.Find("chatmute")

    command.AddChatCommand("colors", self.Plugin, "ColorList")
	command.AddChatCommand("chat", self.Plugin, "Chat")	
	
	if not permission.PermissionExists("canUseFormatting") then permission.RegisterPermission("canUseFormatting", self.Plugin) end
	
	for group, data in pairs(self.Config) do
		permission.RegisterPermission(data.Permission, self.Plugin)
		
		if group == "player" then
			permission.GrantGroupPermission("player", data.Permission, self.Plugin)
		elseif group == "mod" or group == "moderator" then
			permission.GrantGroupPermission("moderator", data.Permission, self.Plugin)
		elseif group == "owner" then
			permission.GrantGroupPermission("admin", data.Permission, self.Plugin)
		end
	end
	
	self:LoadDefaultConfig()
end

function PLUGIN:ColorList(player)
    local colorList = { "aqua", "black", "blue", "brown", "darkblue", "green", "grey", "lightblue", "lime",
        "magenta", "maroon", "navy", "olive", "orange", "purple", "red", "silver", "teal", "white", "yellow"
    }
    local colors = ""
    for k, color in pairs(colorList) do
        if colors == "" then
			colors = "<color=" .. color .. ">" .. string.upper(color) .. "</color>"
		else
			colors = colors .. ", " .. "<color=" .. color .. ">" .. string.upper(color) .. "</color>"
		end
    end
    rust.SendChatMessage(player, "<b><size=25>Available name colors:</size><size=20>" .. colors .. "</size></b>")
end

function PLUGIN:OnPlayerChat(arg)
	local player = arg.connection.player
    local message = arg:GetString(0, "text")
    local uid = rust.UserIDFromPlayer(player)
	
	if string.find(message, "<color=") or string.find(message, "</color>") or string.find(message, "<size=") or string.find(message, "</size>") or string.find(message, "<b>") or string.find(message, "</b>") or string.find(message, "<i>") or string.find(message, "</i>") then
		if not permission.UserHasPermission(userId, "canUseFormatting") then
			rust.SendChatMessage(player, "CHAT", "You may not use formatting tags!")
			return false
		end
	end
	
	if ChatMute then
		isMuted = ChatMute:Call("IsMuted", player)
		if isMuted then return end
	end
	
	if message == "" then return false end
	
	local groups = self.Config
	
	local playerData = {}
	playerData.GroupRank = 0
	for group, data in pairs(self.Config) do
		if permission.UserHasPermission(uid, data.Permission) then
			if data.Rank > playerData.GroupRank then
				playerData.Formatting = data.Formatting
				playerData.GroupRank = data.Rank
				playerData.Title = data.Title
				playerData.TitleColor = data.TitleColor
				playerData.NameColor = data.NameColor
				playerData.TextColor = data.TextColor
				
				playerData.FormattedOutput = playerData.Formatting
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{Rank}", data.Rank)
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{Title}", "<color=" .. data.TitleColor .. ">" .. data.Title .. "</color>")
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{TitleColor}", data.TitleColor)
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{NameColor}", data.NameColor)
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{TextColor}", data.TextColor)
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{Name}", "<color=" .. data.NameColor .. ">" .. player.displayName .. "</color>")
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{ID}", rust.UserIDFromPlayer(player))
				playerData.FormattedOutput = string.gsub(playerData.FormattedOutput, "{Message}", message)
			end
		end
	end
	
	rust.BroadcastChat(playerData.FormattedOutput)
	print(playerData.FormattedOutput)
	
    return false
end
