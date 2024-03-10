#!/usr/bin/env lua

local utilities = require("scripts.utilities")

PWD = utilities.getPresentWorkingDirectory()
HOME = utilities.getHomeDirectory()

distributablePath = PWD .. "/dist/"
buildPath = PWD .. "/build/"
modulesPath = PWD .. "/modules/"
iCloudPath = HOME .. "/Library/Mobile Documents/iCloud~dk~simonbs~Scriptable/Documents/"
devName = " (DEV)"

function init(file)
  print(utilities.getFilePath(iCloudPath .. file))
end

function openInScriptable(filePath)
  local fileBasename = utilities.getBasename("Days Until.js")
  local fileName = utilities.replaceFileExtension(fileBasename, "")
  local uri = utilities.uriEncode(fileName .. devName)

  local openCmd = "open scriptable:///open/" .. uri
  print("Running command: \"" .. openCmd .. "\".")
  local openResult = os.execute(openCmd)

  if openResult == true then
    local runCmd = "open scriptable:///run/" .. uri
    print("Running command: \"" .. runCmd .. "\".")
    os.execute(runCmd)
  end
end

openInScriptable("Scriptable World.ts")
