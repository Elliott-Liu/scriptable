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

function utilities.logEuccess(message)
  print("Success: " .. message)
end

return utilities
