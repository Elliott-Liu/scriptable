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
