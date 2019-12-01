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

function steamLibHandler.UpdateLibraryJson () 

	local library = {
		["Apps"] = {

		}

	}

	local homeEnv = os.getenv("HOME")
	local libDirectory = homeEnv .. "/.local/share/Steam/steamapps/common"

	local libDirTable = scandir(libDirectory)

	for i,v in pairs(libDirTable) do
		if not(v == "." or v == "..") then
			local idFileDir = libDirectory .. "/" .. v .. "/" .. "steam_appid.txt"
			local appIDFile = io.open(idFileDir, "r")
			local content = appIDFile:read()
			io.close(appIDFile)

			library.Apps[v] = {}

			library.Apps[v]["ID"] = tostring(content)
		end
	end

	local jsonLib = io.open("library.json","r+")

	local jsonOutput = json.encode(library)

	jsonLib:write(jsonOutput)

	jsonLib:close()

end

return steamLibHandler