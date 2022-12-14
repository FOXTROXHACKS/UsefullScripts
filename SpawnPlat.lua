--SpawnPlatform(Position here)
function SpawnPlatform(POS)
	local Platform = Instance.new("Part")
	local Decal = Instance.new("Decal")
	
	Platform.Parent = game.Workspace
	Platform.Name = "Platform"
	Platform.BrickColor = BrickColor.new(17, 17, 17)
	Platform.CastShadow = true
	Platform.Material = "Plastic"
	Platform.Size = Vector3.new(26.065, 1, 27.844)
	Platform.Position = POS
	Platform.Anchored = true
	Platform.CanCollide = true
	Platform.Archivable = true
	Platform.CanTouch = true

	Decal.Texture = "rbxassetid://11816966906"
	Decal.Face = "Top"
	Decal.Parent = Platform
	Decal.Archivable = true
end
