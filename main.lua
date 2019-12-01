#! /usr/bin/env lua

-- 23/11/2019

local graphicsLib = require("graphicslib")
local steamLibHandler = require("steamLibHandler")
local term = require("plterm")
local json = require("json")

local function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

local function usage ()
  io.stderr:write("Usage:\n")
  io.stderr:write(
      " < -r > < -id > < game id >\n"
    )
  io.stderr:write("\n")
  io.stderr:write("Example:\n")
  io.stderr:write(
      " Run CS:GO : srunner -r -id 730\n",
      "\n",
      " Yes, I do play CS:GO a lot\n"
    )
  io.stderr:write("\n")
  io.stderr:flush()
  os.exit(1)
end

local function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

local expectedArgs = {
	["ARG1"] = Set {
		"-r"
	},

	["ARG2"] = Set {
		"-id"
	}
}

local ARG1		= select(1, ...) or usage()
local ARG2		= select(2, ...) or usage()
local ARG3		= select(3, ...) or usage()

local function checkArgs ( argument1 , argument2 )
	local arg1Valid = false
	local arg2Valid = false

	if expectedArgs.ARG1[argument1] then
		arg1Valid = true
	else
		io.stderr:write("Argument type: '" .. argument1 .. "' is not valid or does not exist; run 'srunner --help'" , "\n")
	end

	if expectedArgs.ARG2[argument2] then
		arg2Valid = true
	else
		io.stderr:write("Argument type: '" .. argument2 .. "' is not valid or does not exist; run 'srunner --help'" , "\n")
	end

	return arg1Valid, arg2Valid
end

local function checkLibArg ( argument3 )
	local IDValid = false
	local appNameValid = false

	local jsonLib = io.open("library.json","r+")
	local jsonContent = jsonLib:read()
	jsonLib:close()

	local library = json.decode(jsonContent)

	if ARG2 == "-id" then
		for i,v in pairs(library.Apps) do
			if library.Apps[i]["ID"] == argument3 then
				IDValid = true
			end
		end

		if not IDValid then
			io.stderr:write("App ID: '" .. argument3 .. "' does not exist or is not an installed app" , "\n")
		end
	end

	return IDValid
end

steamLibHandler.UpdateLibraryJson()

isArg1Valid, isArg2Valid = checkArgs( ARG1 , ARG2 )

isIDValid = checkLibArg( ARG3 )

if isArg1Valid and isArg2Valid and isIDValid then
	io.stderr:write('App loading...' , "\n")

	os.execute("steam steam://rungameid/" .. ARG3 .. "&> /dev/null 2>&1")

end

--[[term.clear()
local defaultMode = term.savemode()
term.setrawmode()
term.hide()]]

--scrl, scrc = term.getscrlc()

--local label = graphicsLib.NewLabel("bruh")
--io.write(label.text)

--local box = graphicsLib.NewBox(scrc,scrl)

--os.execute("steam steam://rungameid/730 > /dev/null 2>&1")
--os.execute("disown")

--sleep(5)


--term.restoremode(defaultMode)
--term.setsanemode()
--term.reset()
--term.show()