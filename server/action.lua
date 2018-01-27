
local iup = require("iuplua")
local fun = require("functions")
local gui = require("server.layout")
local sro = require("server.import")
local act = { min = 1 }

-- action functions

function act.clean()
	local data = fun.alldata()
	for i,v in pairs(data) do
		local diffdata = fun.diffdata(v)
		if diffdata > 30 * 24 * 60 or (diffdata > 60  and v:match("(%d%d)m") ~= "00") then
			os.remove(string.format("data/srodata-%s.lua", v))
			os.remove(string.format("data/ldidata-%s.lua", v))
			os.remove(string.format("data/objdata-%s.lua", v))
			os.remove(string.format("data/csvdata-%s.csv", v))
		end
	end
end

function act.question(message)
	local dlg = iup.messagedlg{
		title      = "Confirmar",
		value      = message,
		buttons    = "YESNO",
		dialogtype = "QUESTION"
	}
	dlg:popup()
	return dlg.buttonresponse == "1"
end

-- callback functions

function gui.dialog:close_cb()
	if act.question("Sair do Servidor de Posta Restante?") then
		self:hide()
	else
		return iup.IGNORE
	end
end

function gui.dialog:k_any(k)
	if k == iup.K_ESC then
		self:close_cb()
	end
end

function gui.dialog:trayclick_cb(b, press, dclick)
	if b == 1 and press then
		if self.visible == "YES" then
			self.hidetaskbar = "YES"
		else
			self.hidetaskbar = "NO"
		end
	end
end

gui.timer = iup.timer{
	time = 1000 * (act.min * 60)
}

function gui.timer:action_cb()
	gui.status.title = sro.import()
	act.clean()
end

gui.server.title = "Concentrador SRO: " .. sro.server

local diffdata = fun.diffdata()
if not diffdata or diffdata >= 1.5 then
	gui.timer:action_cb()
	gui.timer.run = "YES"
	--gui.dialog.hidetaskbar = "YES"
else
	gui.status.title = string.format(
[[
Sua última sincronização foi a menos
de %d minuto. Talvez já tenha um servidor
rodando. Senão tente mais tarde.
]], act.min)
end

return act
