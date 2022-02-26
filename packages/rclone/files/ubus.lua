#!/usr/bin/env lua

local ubus = require "ubus"
local uloop = require "uloop"
local cjson = require "cjson"
local inotifylib = require 'inotify'
local os = require "os"
local uci = require("uci").cursor()
local cname = "rclone"
local CONFIG_FILE = os.getenv("RCLONE_CONFIG")
uloop.init()

local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubus")
end
local function readconf(file)
    local getLine = io.lines(file)
    local table = {}
    while true do
        local remote = getLine()
        if remote == nil then
            return table
        end
        remote = string.sub(remote, 2, -2) -- drop the brackets
        local values = {}
        table[remote] = values
        for line in getLine do
            if line == "" then
                break
            end
            local _, _, name, value = string.find(line, "^([^%s]+) = (.*)$")
            values[name] = value
        end
    end
end

local function cleansection(s)
    for name, _ in pairs(s) do
        if string.find(name, "^%..*$") ~= nil then
            s[name] = nil
        end
    end
end

local function currentConfig()
    local table = {}
    uci:foreach(cname, "remote", function(s)
        local remote = s[".name"]
        cleansection(s)
        table[remote] = s
    end)
    return table
end
local function issubset(remote1, remote2)
    for name, value1 in pairs(remote1) do
        local value2 = remote2[name]
        if value2 == nil or value2 ~= value1 then
            return false
        end
    end
    return true
end

local function isequal(remote1, remote2)
    return issubset(remote1, remote2) and issubset(remote2, remote1)
end
local function diff(newconf, oldconf)
    local added = {}
    local removed = {}
    for name, remote in pairs(newconf) do
        local oldremote = oldconf[name]
        if oldremote == nil then
            added[name] = remote
        elseif not isequal(remote, oldremote) then
            added[name] = remote
            removed[name] = oldremote
            oldconf[name] = nil
        else
            oldconf[name] = nil
        end
    end
    for name, oldremote in pairs(oldconf) do
        removed[name] = oldremote
        oldconf[name] = nil
    end
    return added, removed
end

local function update_config()
    local newconf = readconf(CONFIG_FILE)
    local oldconf = currentConfig()

    local added, removed = diff(newconf, oldconf)
    for name, _ in pairs(removed) do
        uci:delete(cname, name)
    end
    for remotename, remote in pairs(added) do
        uci:set(cname, remotename, "remote")
        for option, value in pairs(remote) do
            uci:set(cname, remotename, option, value)
        end
    end
    -- print("============changes=================")
    -- require'pl.pretty'.dump(uci:changes())
    print("Updating config")
    uci:commit(cname)
end

local function shell(cmd)
    local handle = assert(io.popen(cmd), "error")
    local result = handle:read("*a")
    handle:close()
    if result == nil then
        return nil
    elseif string.sub(result, 0, 1) == "{" then
        return cjson.decode(result)
    else
        return nil
    end
end

local function exec_rc_cmd(cmd_method, cmd_json)
    local cmd = " rclone rc " .. cmd_method
    if cmd_json then
        cmd = cmd .. " --json '" .. cjson.encode(cmd_json) .. "'"
    end
    return shell(cmd)
end

local function handler(method)
    return function(req, msg)
        local result = exec_rc_cmd(method, msg)
        if result == nil then
            return 0
        else
            conn:reply(req, exec_rc_cmd(method, msg));
            return 0
        end
    end, {
        id = ubus.INT32,
        msg = ubus.STRING
    }
end
local function update(req, msg)
    update_config()
    return 0
end

local rclone_api = {}
local schema = shell("rclone rc rc/list --loopback")
for _, command in ipairs(schema.commands) do
    for scope, method in string.gmatch(command.Path, "(%w+)/(%w+)") do
        local obj = rclone_api["rclone." .. scope]
        if obj == nil then
            obj = {}
            rclone_api["rclone." .. scope] = obj
        end
        obj[method] = {handler(command.Path)}
    end
end
rclone_api["rclone.rc"]["update"] = {update, {
    id = ubus.INT32,
    msg = ubus.STRING
}}

conn:add(rclone_api)
local inotify = inotifylib.init()
inotify:addwatch(CONFIG_FILE, inotifylib.IN_MODIFY)
uloop.fd_add(inotify, function(ufd, _)
    print("detected changes to " .. CONFIG_FILE .. ". ")
    local events = ufd:read()
    update_config()
end, uloop.ULOOP_READ)

uloop.run()
inotify:close()
