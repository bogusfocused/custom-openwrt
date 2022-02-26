#!/usr/bin/env lua

local uci = require("uci").cursor()
local CONFIG = "rclone"
local CONFIG_GLOBALS = "globals"

local function dumpconfig(...)
    uci:foreach(CONFIG, "remote", function(s)
        local remote = s[".name"]
        io.write("[", remote, "]", "\n")
        for name, value in pairs(s) do
            if string.find(name, "^%..*$") == nil then
                io.write(name, " = ", value, "\n")
            end
        end
        io.write("\n")
    end)
end

local function readglobals(data)
    local table = {
        port = "5572",
        noauth = true
    }
    for name, value in pairs(data) do
        if string.find(name, "^%..*$") == nil then
            if name == "interface" then
                table.ipaddr = uci.get("network", value, "ipaddr")
            else
                table[name] = value
            end
        end
    end
    if table.ipaddr == nil then
        table.ipaddr = "127.0.0.1"
    end
    table.noauth = table.ipaddr == "127.0.0.1"
    return table
end

local function readrc(data)
    local table = {}
    for name, value in pairs(data) do
        if string.find(name, "^%..*$") == nil then
            name = string.gsub(name:upper(), "-", "_")
            table["RCLONE_RC_" .. name] = value
        end
    end
    return table
end

local function readrclone(data)
    local table = {
        RCLONE_RC_WEB_GUI_NO_OPEN_BROWSER = "true",
        RCLONE_CACHE_DIR = "/var/rclone/cache"

    }
    for name, value in pairs(data) do
        if string.find(name, "^%..*$") == nil then
            name = string.gsub(name:upper(), "-", "_")
            table["RCLONE_" .. name] = value
        end
    end
    return table
end

local function readconfig()
    local rclone = {}
    local rc = {}
    local globals = {}
    uci:foreach(CONFIG, CONFIG_GLOBALS, function(data)
        local section = data[".name"]
        if section == CONFIG_GLOBALS then
            globals = readglobals(data)
        elseif section == "rclone" then
            rclone = readrclone(data)
        elseif section == "rc" then
            rc = readrc(data)
        end
    end)
    return globals, rclone, rc
end

local function dumpenv(...)
    local globals, rclone, rc = readconfig()
    -- overwrite if there are any duplicate options
    for k, v in pairs(rc) do
        rclone[k] = v
    end
    if globals.noauth or rclone.RCLONE_RC_USER == nil or rclone.RCLONE_RC_PASS == nil then
        rclone.RCLONE_RC_USER = nil
        rclone.RCLONE_RC_PASS = nil
        rclone.RCLONE_RC_NO_AUTH = "true"
    else
        rclone.RCLONE_RC_NO_AUTH = nil
    end
    local env = ""
    -- First pair is ipaddr
    if rclone.RCLONE_RC_ADDR == nil then
        rclone.RCLONE_RC_ADDR = globals.ipaddr .. ":" .. globals.port
    end
    env = "RCLONE_RC_ADDR " .. rclone.RCLONE_RC_ADDR
    rclone.RCLONE_RC_ADDR = nil
    -- second pair
    if rclone.RCLONE_RC_NO_AUTH ~= nil then
        env = env .. " RCLONE_RC_NO_AUTH " .. rclone.RCLONE_RC_NO_AUTH
    else
        env = env .. " RCLONE_RC_USER " .. rclone.RCLONE_RC_USER
        env = env .. " RCLONE_RC_PASS " .. rclone.RCLONE_RC_PASS
    end
    rclone.RCLONE_RC_NO_AUTH = nil
    rclone.RCLONE_RC_USER = nil
    rclone.RCLONE_RC_PASS = nil

    os.execute("mkdir -p " .. rclone.RCLONE_CACHE_DIR)
    rclone.RCLONE_CONFIG = nil
    for name, value in pairs(rclone) do
        env = env .. ' ' .. name .. ' ' .. value
    end
    io.output():write(env)
end
local function dumpconf(...)
    local enabled = uci:get(CONFIG, CONFIG_GLOBALS, "enabled")
    if enabled ~= "1" then
        error("rclone-server is disabled in config.", 0)
    end
    local filename = uci:get(CONFIG, "rclone", "config")
    if filename ~= nil then
        local file, err = io.open(filename, 'rb')
        if file then
            io.write(file:read '*a')
        else
            error(filename .. ": " .. err, 0)
        end
    else
        dumpconfig()
    end
end

local public = {
    dumpconfig = dumpconf,
    dumpenv = dumpenv
}

---@diagnostic disable-next-line: deprecated
public[arg[1]](unpack(arg, 2))
