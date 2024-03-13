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

function utilities.fileExists(filePath)
  local file = io.open(filePath, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
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

local base64IndexTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function toBinary(byte)
  local binary = ""
  for i = 8, 1, -1 do
    binary = binary .. ((byte % 2 ^ i - byte % 2 ^ (i - 1) > 0) and "1" or "0")
  end
  return binary
end

local function fromBinaryToBase64(binary)
  local base64 = ""
  for i = 1, #binary, 6 do
    local byte = binary:sub(i, i + 5)
    if #byte < 6 then
      break
    end
    local index = tonumber(byte, 2) + 1
    base64 = base64 .. base64IndexTable:sub(index, index)
  end
  return base64
end

function utilities.base64Encode(data)
  local binaryString = data:gsub(".", function(char)
    return toBinary(char:byte())
  end)

  local base64 = fromBinaryToBase64(binaryString)
  local padding = ("="):rep((4 - #base64 % 4) % 4)

  return base64 .. padding
end

return utilities
