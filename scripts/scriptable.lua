#!/usr/bin/env lua

local utilities = require("scripts.utilities")
local lfs = require("lfs") -- LuaFileSystem for file operations

PWD = utilities.getPresentWorkingDirectory()
HOME = utilities.getHomeDirectory()

scriptsPath = PWD .. "/src/scripts/"
distributablePath = PWD .. "/dist/"
buildPath = PWD .. "/build/"
modulesPath = PWD .. "/modules/"
iCloudPath = HOME .. "/Library/Mobile Documents/iCloud~dk~simonbs~Scriptable/Documents/"
devName = " (DEV)"

function addDevName(string)
  return string .. devName
end

function init(file)
  print(utilities.getFilePath(iCloudPath .. file))
end

function openInScriptable(filePath)
  local fileBasename = utilities.getBasename(filePath)
  local fileName = utilities.replaceFileExtension(fileBasename, "")
  local uri = utilities.uriEncode(addDevName(fileName))

  local openCmd = "open scriptable:///open/" .. uri
  print("Running command: \"" .. openCmd .. "\".")
  local openResult = os.execute(openCmd)

  if openResult == true then
    local runCmd = "open scriptable:///run/" .. uri
    print("Running command: \"" .. runCmd .. "\".")
    os.execute(runCmd)
  end
end

-- Constructs the rollup command based on the file path and parameters.
-- @param filePath The file path to include in the command.
-- @param arguments The additional parameters for the build process.
-- @return The constructed command.
local function constructRollupCommand(filePath, arguments)
  local cmd = "rollup --config rollup.config.ts --environment file_path:" .. utilities.base64Encode(filePath)
  if utilities.hasArgument("--watch", arguments) then
    cmd = cmd .. " --watch"
  end
  return cmd
end

-- Searches for a TypeScript file in the specified directory and its subdirectories.
-- @param src The source directory to search in.
-- @param targetFileName The name of the TypeScript file to search for.
-- @return The path to the found TypeScript file or nil if not found, and a status code (0 for found, 1 for not found).
local function findTsFile(src, targetFileName)
  for entry in lfs.dir(src) do
    if entry ~= "." and entry ~= ".." then
      local path = src .. "/" .. entry
      local mode = lfs.attributes(path, "mode")

      if mode == "directory" then
        -- Recursively search in the subdirectory.
        local foundPath, status = findTsFile(path, targetFileName)
        if status == 0 then
          return foundPath, 0
        end
      elseif mode == "file" and entry == targetFileName then
        -- TypeScript file found.
        return path, 0
      end
    end
  end
  -- TypeScript file not found in this directory or its subdirectories.
  return nil, 1
end

-- The build function, which orchestrates the build process.
-- @param entryFilePath The entry file path for the build process.
-- @param ... Additional parameters for the build process.
local function build(entryFilePath, ...)
  local arguments = {...}
  local expectedParsedPath, status

  if startsWith(entryFilePath, "./" .. src .. "/") then
    expectedParsedPath, status = findTsFile(src, entryFilePath)
    if status == 1 then
      logError("The expected TypeScript file \"" .. expectedParsedPath .. "\" does not exist.")
      os.exit(1)
    end
  end

  if not startsWith(entryFilePath, "./") then
    expectedParsedPath, status = findTsFile(".", entryFilePath .. ".ts")
    if status == 1 then
      logError("\"" .. entryFilePath .. ".ts\" could not be found!")
      os.exit(1)
    else
      logSuccess("We found the script at: \"" .. expectedParsedPath .. "\".")
    end
  end

  local cmd = constructRollupCommand(expectedParsedPath, arguments)

  -- os.execute(cmd)

  utilities.logSuccess("Done!")
end

-- Builds and watches the TypeScript project.
-- @param entryFilePath The entry file path for the build and watch process.
local function buildAndWatch(entryFilePath)
  build(entryFilePath, "--watch")
end
