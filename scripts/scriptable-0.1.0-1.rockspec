package = "scriptable"
version = "0.1.0-1"
source = {
  url = "file://."
}
description = {
  summary = "Scriptable development environment utilities.",
  detailed = "",
}
dependencies = {
  "lua >= 5.4",
  "luafilesystem"
}
build = {
  type = "builtin",
  modules = {
    scriptable = "scripts/scriptable.lua",
    utilities = "scripts/utilities.lua",
  }
}
