local M = {}

local awful = require("awful")

M.backlights = {}

M.backlights.get_interface = function()
	local interfaces = {}
	awful.spawn.easy_async_with_shell("ls /sys/class/backlight", function(stdout)
		for token in string.gmatch(stdout, "[^%s]+") do
			table.insert(interfaces, token)
		end
	end)
	return interfaces
end

M.backlights.interface = M.backlights.get_interface()

M.backlights.command = function(control)
	for _, interface in ipairs(M.backlights.interface) do
		awful.spawn("xbacklight -ctrl " .. interface .. " " .. control)
	end
end

M.backlights.set = function(value)
	M.backlights.command(string.format("-set %d", value))
end

M.backlights.increase = function(value)
	M.backlights.command(string.format("-inc %d", value))
end

M.backlights.decrease = function(value)
	M.backlights.command(string.format("-dec %d", value))
end

M.backlights.set(80)

M.audio = {}

M.audio.command = function(control)
	local command = "amixer -D pulse " .. control .. " | grep 'Right: ' | awk -F '[][]' '{print $2 $4}'"
	awful.spawn.easy_async_with_shell(command, function(stdout)
		local tokens = {}
		for token in string.gmatch(stdout, "[^%%%s]+") do
			table.insert(tokens, token)
		end
		local volume = tonumber(tokens[1])
		local status = tostring(tokens[2])
		awesome.emit_signal("volume_change", volume, status)
	end)
end

M.audio.toggle = function()
	M.audio.command("set Master 1+ toggle")
end

M.audio.set = function(value)
	M.audio.command(string.format("sset Master %d%%", value))
end

M.audio.increase = function(value)
	M.audio.command(string.format("sset Master %d%%+", value))
end

M.audio.decrease = function(value)
	M.audio.command(string.format("sset Master %d%%-", value))
end

return M
