PLUGIN.Title        = "Portals"
PLUGIN.Description  = "Set a portal"
PLUGIN.Author       = "LaserHydra"
PLUGIN.Version      = V(1,0,0)

function PLUGIN:Init()
	self:LoadDefaultConfig()
end

function PLUGIN:LoadDefaultConfig()
	self.Config.Entrance = self.Config.Entrance or {}
	self.Config.Exit = self.Config.Exit or {}
	
	self.Config.TeleportTimer = self.Config.TeleportTimer or 15
	self.Config.TeleportRadius = self.Config.TeleportRadius or 5
	
	self.Config.Entrance.PosX = self.Config.Entrance.PosX or 0
	self.Config.Entrance.PosY = self.Config.Entrance.PosY or 0
	self.Config.Entrance.PosZ = self.Config.Entrance.PosZ or 0
	
	self.Config.Exit.PosX = self.Config.Exit.PosX or 0
	self.Config.Exit.PosY = self.Config.Exit.PosY or 0
	self.Config.Exit.PosZ = self.Config.Exit.PosZ or 0
end

timer.Repeat(self.Config.TeleportTimer, 0 function()
	local PortalPos = Vector3.Vector3(self.Config.Entrance.PosX, self.Config.Entrance.PosY, self.Config.Entrance.PosZ)
	local players = global.BasePlayer.activePlayerList:GetEnumerator()
	while players:MoveNext() do
		if Vector3.Distance(player.Current.transform.position, PotalPos) <= self.Config.TeleportRadius then
			rust.ForcePlayerPosition(players.Current, self.Config.Exit.PosX, self.Config.Exit.PosY, self.Config.Exit.PosZ)
		end
	end
end)
