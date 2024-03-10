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

function utilities.logError(message)
  print("Error: " .. message)
end

function utilities.logSuccess(message)
  print("Success: " .. message)
end

function utilities.logComplete(message)
  print("Complete: " .. message)
end

return utilities
