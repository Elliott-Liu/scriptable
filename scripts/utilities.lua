utilities = {}

function utilities.getPresentWorkingDirectory()
  return os.getenv("PWD");
end

function utilities.getHomeDirectory()
  return os.getenv("HOME")
end

function utilities.getFileName(filePath)
  return filePath:match("([^/]+)$")
end

function utilities.getFilePath(filePath)
  return filePath:match("(.+)/[^/]*$")
end

function utilities.getBasename(filePath)
  local name = string.gsub(filePath, "(.*/)(.*)", "%2")
  return name
end

-- Checks if a string starts with a given prefix.
-- @param str The string to check.
-- @param prefix The prefix to check against the string.
-- @return True if the string starts with the prefix, false otherwise.
function utilities.startsWith(str, prefix)
  return str:sub(1, #prefix) == prefix
end

function utilities.replaceFileExtension(filePath, extension)
  local name = utilities.getBasename(filePath)
  local basename = string.match(name, "(.+)%..+") or name

  if extension == nil or extension == "" then
    return filePath:gsub(name .. "$", basename)
  else
    if string.sub(extension, 1, 1) ~= "." then
      extension = "." .. extension
    end
    return filePath:gsub(name .. "$", basename .. extension)
  end
end

function utilities.uriEncode(string)
  string = string.gsub(string, "([^%w _%%%-%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  string = string.gsub(string, " ", "%%20")
  return string
end

function utilities.hasArgument(argument, arguments)
  for _, value in ipairs(arguments) do
    if value == argument then
      return true
    end
  end
  return false
end

-- Logs an error message.
-- @param message The error message to log.
function utilities.logError(message)
  print("Error: " .. message)
end

-- Logs a success message.
-- @param message The success message to log.
function utilities.logSuccess(message)
  print("Success: " .. message)
end

-- Logs a completion message.
-- @param message The completion message to log.
function utilities.logComplete(message)
  print("Complete: " .. message)
end

return utilities
