local config = require("@core/config")

local old = getgenv()[config.Name]
if old and old.Unload then
    pcall(old.Unload)
end

local route = require("@routes/Main/main")
route()
