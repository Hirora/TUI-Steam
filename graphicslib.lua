-- 23/11/2019

local lib = {}

local term = require("plterm")

local charLib = {
	["pipes"] = {
		[1] 	= "┃",
		[2] 	= "┏",
		[3] 	= "┓",
		[4] 	= "┛",
		[5] 	= "━┓",
		[6] 	= "┗",
		[7] 	= "┛",
		[8] 	= "┗",
		[9] 	= "┏━",
		[10]	= "━"
	}
}

function DrawBoxHeader ( width , isBottom , leftCornerChar , rightCornerChar , outlineChar)
	for i = 1,width do
		if i == 1 then
			io.write(leftCornerChar)
		elseif i == width then
			if not isBottom then
				io.write(rightCornerChar , "\n")
			else
				io.write(rightCornerChar)
			end
			local y,x = term.getcurpos()
			term.golc(y,1)
		else
			io.write(outlineChar)
		end
	end
end

function DrawBoxSides ( width , height , outlineChar)
	for v = 1,height-2 do
		for i = 1,width do
			if i == 1 then
				io.write(outlineChar)
			elseif i == width then
				io.write(outlineChar , "\n")
				local y,x = term.getcurpos()
				term.golc(y,1)
			else
				term.right()
			end
		end
	end
end

function DrawBox ( width , height )
	local tlCorner = charLib["pipes"][2]
	local trCorner = charLib["pipes"][3]
	local blCorner = charLib["pipes"][8]
	local brCorner = charLib["pipes"][7]

	local vLine = charLib["pipes"][1]		-- Vertical Line 
	local hLine = charLib["pipes"][10]		-- Horizontal Line

	DrawBoxHeader(width, false, tlCorner, trCorner, hLine)
	DrawBoxSides (width, height, vLine)
	DrawBoxHeader(width, true, blCorner, brCorner, hLine)
end


function lib.NewLabel ( text )
	local label = {}
	label.text = text

	return label
end

function lib.NewBox ( width , height )
	local box = {}
	box.width = width
	box.height = height

	DrawBox(width,height)

	return box
end

return lib