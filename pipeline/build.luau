local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")
local luau = require("@lune/luau")
local datetime = require("@lune/datetime")
local stdio = require("@lune/stdio")

local configPath = process.args[1] or "pipeline/.pcmp.json"
local buildName = process.args[2] or "Release"
local version = process.args[3] or "v0.0.0"
local darklua = process.env.DARKLUA or "darklua"

local function fail(message)
    stdio.ewrite("build failed: " .. message .. "\n")
    process.exit(1)
end

local settings = serde.decode("json", fs.readFile(configPath))
local build
for _, cfg in ipairs(settings.buildConfigs) do
    if cfg.name == buildName then
        build = cfg
    end
end
if not build then
    fail("no build config named " .. buildName)
end

local exec = process.exec or process.spawn
local result = exec(darklua, { "process", build.input, build.output, "-c", build.darkluaConfig })
if not result.ok then
    fail("darklua exited " .. tostring(result.code) .. "\n" .. result.stderr .. result.stdout)
end

local bundle = fs.readFile(build.output)
local values = {
    genDate = datetime.now():toIsoDate(),
    cfg = build.name,
    vers = version,
}
local frame = fs.readFile(build.frame)
local output = frame:gsub("{{(%w+)}}", function(key)
    if key == "build" then
        return bundle
    end
    return values[key] or ""
end)

local compiled, compileError = pcall(luau.compile, output)
if not compiled then
    fail("output does not compile: " .. tostring(compileError))
end

local stripped = output:gsub("%[(=*)%[.-%]%1%]", ""):gsub('"[^"\n]*"', ""):gsub("'[^'\n]*'", "")
if stripped:find("%-%-") then
    fail("output still contains a comment")
end
for _, name in ipairs({ "print", "warn" }) do
    if stripped:find("%f[%w_]" .. name .. "%f[^%w_]") then
        fail("output still calls " .. name)
    end
end

fs.writeFile(build.output, output)
stdio.write(("%s %s -> %s (%d bytes)\n"):format(build.name, version, build.output, #output))
