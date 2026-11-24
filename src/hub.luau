local Repo = "https://raw.githubusercontent.com/rapierhub/degraded/main/dist/"

local Games = {
    { name = "Degraded", file = "degraded.luau", places = { 107088339391423, 107103871057311 } },
    { name = "Voxel Wars", file = "voxelwars.luau", places = { 78884249003161 } },
    { name = "TTK", file = "ttk.luau", places = { 120189115846709 } },
    { name = "Grapple Sniper Arena", file = "grapplesniper.luau", places = { 75407502025821 } },
    { name = "Blackhawk Rescue Mission 5", file = "brm5.luau", places = { 13622622708, 5468388011 } },
}

local function find()
    for _, g in ipairs(Games) do
        for _, id in ipairs(g.places) do
            if id == game.PlaceId then
                return g
            end
        end
    end
    return nil
end

local entry = find()
if not entry then
    error(("hub: no script for PlaceId %d"):format(game.PlaceId), 0)
end

local ok, source = pcall(game.HttpGet, game, Repo .. entry.file)
if not ok or type(source) ~= "string" or source == "" then
    error("hub: failed to download " .. entry.file, 0)
end
local chunk, err = loadstring(source, "=" .. entry.name)
if not chunk then
    error("hub: " .. tostring(err), 0)
end
chunk()
