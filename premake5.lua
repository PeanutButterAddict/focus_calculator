-- To use fil-c compiler
local prefix = path.getabsolute("../filc-0.674-linux-x86_64/build/bin")
local clang = premake.tools.clang

clang.tools = {
	cc = prefix .. "/clang",
}

function clang.gettoolname(cfg, tool)
	return clang.tools[tool]
end

workspace("PeanutButterAddict")
configurations({ "debug", "release" })
location("build")
toolset("clang") -- Comment for gcc instead.


project("focus_calculator")
kind("ConsoleApp")
language("C")
location("build")
targetdir("bin")

files({ "src/**.h", "src/**.c" })

filter("configurations:debug")
-- Currently using asserts to stop certain actions.
-- targetname("%{prj.name}_%{cfg.buildcfg}")
defines({ "DEBUG" })
symbols("On")

filter("configurations:release")
defines({ "NDEBUG" })
optimize("On")
