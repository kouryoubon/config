local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "cmake_project",
    fmt(
      [[
cmake_minimum_required(VERSION {version})

project({project_name} LANGUAGES {languages})

add_executable({exe_name} {sources})
]],
      {
        version = i(1, "4.21"), -- CMake version
        project_name = i(2, "MyProject"), -- project name
        languages = i(3, "CXX"), -- languages (C, CXX, etc.)
        exe_name = i(4, "my_executable"), -- executable name
        sources = i(5, "main.cpp"), -- sources
      }
    )
  ),
}
