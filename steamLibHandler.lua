-- 28/11/2019

local steamLibHandler = {}

local json = require("json")

-- Lua implementation of PHP scandir function
local function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function steamLibHandler.UpdateLibraryJson () 

	local library = {
		["Apps"] = {

		}

	}

	local homeEnv = os.getenv("HOME")
	local libDirectory = homeEnv .. "/.steam/steam/steamapps/common"

	local libDirTable = scandir(libDirectory)

	for i,v in pairs(libDirTable) do
		if not(v == "." or v == "..") then
			if file_exists(libDirectory .. "/" .. v .. "/" .. "steam_appid.txt") then
				local idFileDir = libDirectory .. "/" .. v .. "/" .. "steam_appid.txt"
				local appIDFile = io.open(idFileDir, "r")
				local content = appIDFile:read()
				io.close(appIDFile)

				library.Apps[v] = {}

				library.Apps[v]["ID"] = tostring(content)
			else
				library.Apps[v] = {}

				library.Apps[v]["ID"] = tostring("Unavailable")
			end
		end
	end

	local jsonLib = io.open("library.json","r+")

	local jsonOutput = json.encode(library)

	jsonLib:write(jsonOutput)

	jsonLib:close()

end

return steamLibHandler