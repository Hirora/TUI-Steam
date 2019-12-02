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
  	  "\n",
      " < -r > < -id > < game id >\n"
    )
  io.stderr:write("\n")
  io.stderr:write("Example:\n")
  io.stderr:write(
  	  "\n",
      " Run CS:GO : srunner -r -id 730\n",
      "\n"
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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local expectedArgs = {
	["EXCEPTIONS"] = {
		["-r"] = {
			["ARG2"] = Set {
				"APPID"
			},
			["ARG3"] = Set {
				"APPID",
				"NIL"
			}
		},
		["-ls"] = {
			["ARG2"] = Set {
				"NIL"
			},
			["ARG3"] = Set {
				"NIL"
			}
		}
	},

	["-r"] = {
		["ARG2"] = Set {
			"-id"
		},
		["ARG3"] = Set {

		}
	},

	["-ls"] = {
		["ARG2"] = Set {
			
		},
		["ARG3"] = Set {

		}
	}
}

local argFunctions = {
	["-r"] = function ( argument2 , argument3 ) 
		if argument2 == "-id" then
			io.stderr:write('App loading...' , "\n")
			os.execute("steam steam://rungameid/" .. argument3 .. "&> /dev/null 2>&1")
		else
			io.stderr:write('App loading...' , "\n")
			os.execute("steam steam://rungameid/" .. argument2 .. "&> /dev/null 2>&1")
		end
	end,
	
	["-ls"] = function ()
		io.write('Apps:\n')

		local jsonLib = io.open("library.json","r+")
		local jsonContent = jsonLib:read()
		jsonLib:close()
		local library = json.decode(jsonContent)

		local count = 1

		for i,v in pairs(library.Apps) do
			if count < tablelength(library.Apps) then
				io.write('├┬ ',i,"\n")
				io.write('┆└─╼ App ID: ' , v.ID , '\n')
				io.write('┆\n')
				
			else
				io.write('└┬ ',i,"\n")
				io.write(' └─╼ App ID: ' , v.ID , '\n')
			end

			count = count+1
		end

	end
}

local ARG1		= select(1, ...)
local ARG2		= select(2, ...)
local ARG3		= select(3, ...)

function isID ( suspect )
	local valid = false

	local jsonLib = io.open("library.json","r+")
	local jsonContent = jsonLib:read()
	jsonLib:close()
	local library = json.decode(jsonContent)

	for i,v in pairs(library.Apps) do
		if library.Apps[i]["ID"] == suspect then
			valid = true
		end
	end

	return valid
end

function expectsID ( argTable )
	local valid = false

	for i,v in pairs(argTable) do
		if i == "APPID" then
			valid = true
		end
	end

	return valid
end

function expectsNIL ( argTable )
	local valid = false

	for i,v in pairs(argTable) do
		if i == "NIL" then
			valid = true
		end
	end

	return valid
end

function validateArgs ( argument1 , argument2 , argument3 )
	local valid = false

	local arg1Valid = false
	local arg2Valid = false
	local arg3Valid = false

	if expectedArgs[argument1] then
		arg1Valid = true
	else
		io.stderr:write("Argument type: '" .. argument1 .. "' is not valid or does not exist; run 'srunner --help'" , "\n")
	end

	if arg1Valid then
		if expectedArgs[argument1].ARG2[argument2] then
			arg2Valid = true
		elseif isID(argument2) and expectsID(expectedArgs.EXCEPTIONS[argument1].ARG2) or expectsNIL(expectedArgs.EXCEPTIONS[argument1].ARG3) then
			arg2Valid = true
		else
			if argument2 then
				io.stderr:write("Argument type: '" .. argument2 .. "' is not valid or does not exist; run 'srunner --help'" , "\n")
			else
				io.stderr:write("Argument 2 is not valid or does not exist; run 'srunner --help'" , "\n")
			end
			
		end

		if expectedArgs[argument1].ARG3[argument3] then
			arg3Valid = true
		elseif isID(argument3) and expectsID(expectedArgs.EXCEPTIONS[argument1].ARG3) or expectsNIL(expectedArgs.EXCEPTIONS[argument1].ARG3) then
			arg3Valid = true
		else
			if argument3 then
				io.stderr:write("Argument type: '" .. argument3 .. "' is not valid or does not exist; run 'srunner --help'" , "\n")
			else
				io.stderr:write("Argument 3 is not valid or does not exist; run 'srunner --help'" , "\n")
			end
		end

		if arg1Valid and arg2Valid and arg3Valid then
			valid = true
		end
	end

	return valid
end

--[[local function checkArgs ( argument1 , argument2 )
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
		local jsonLib = io.open("library.json","r+")
		local jsonContent = jsonLib:read()
		jsonLib:close()

		local library = json.decode(jsonContent)

		for i,v in pairs(library.Apps) do
			if library.Apps[i]["ID"] == argument2 then
				arg2Valid = true
			end
		end

		if not arg2Valid then
			io.stderr:write("Argument type: '" .. argument2 .. "' is not valid or does not exist; run 'srunner --help'" , "\n")
		end
	end

	return arg1Valid, arg2Valid
end]]

--[[local function checkLibArg ( argument3 )
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
	else
		IDValid = true
	end

	return IDValid
end]]

steamLibHandler.UpdateLibraryJson()

if validateArgs(ARG1,ARG2,ARG3) then
	argFunctions[ARG1](ARG2,ARG3)
end

--[[isArg1Valid, isArg2Valid = checkArgs( ARG1 , ARG2 )

isIDValid = checkLibArg( ARG3 )

if isArg1Valid and isArg2Valid and isIDValid then
	--io.stderr:write('App loading...' , "\n")

	--os.execute("steam steam://rungameid/" .. ARG3 .. "&> /dev/null 2>&1")
	expectedArgs.ARG1[ARG1]( ARG2 , ARG3 )
end]]






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