#!/usr/bin/env lua

local utilities = require("scripts.utilities")

PWD = utilities.getPresentWorkingDirectory()
HOME = utilities.getHomeDirectory()

distributablePath = PWD .. "/dist/"
buildPath = PWD .. "/build/"
modulesPath = PWD .. "/modules/"
iCloudPath = HOME .. "/Library/Mobile Documents/iCloud~dk~simonbs~Scriptable/Documents/"

function init(file)
  print(utilities.getFilePath(iCloudPath .. file))
end

init("Scriptable World.ts")
