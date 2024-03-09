#!/usr/bin/env lua

local utilities = require("scripts.utilities")

local rockspecPath = "./scripts/scriptable-0.1.0-1.rockspec"

local function installRockspec(rockspecPath)
  local rockspecFileName = utilities.getFileName(rockspecPath)
  print("Attempting to install " .. rockspecFileName .. " file.")

  local command = "luarocks make " .. rockspecPath .. " 2>&1"
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  if result:match("is now installed in") then
    print(rockspecFileName .. " and its dependencies have been installed successfully.")
  else
    print("Installation of " .. rockspecFileName .. " failed. Details:\n" .. result)
  end
end

installRockspec(rockspecPath)
