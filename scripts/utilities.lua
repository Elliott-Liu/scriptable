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

return utilities
