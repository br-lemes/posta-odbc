
local iup = require("iuplua")
local eng = require("engine")
local gui = require("layout")
local ico = require("icons")

gui.select_timer = iup.timer{
	time      = 2500,
	run       = "NO",
	action_cb = function () gui.search.selection = "ALL" end
}

gui.clipboard = iup.clipboard{}

function gui.question(message)
	local dlg = iup.messagedlg{
		title      = "Confirmar",
		value      = message,
		buttons    = "YESNO",
		dialogtype = "QUESTION"
	}
	dlg:popup()
	return dlg.buttonresponse == "1"
end

function gui.dialog:close_cb()
	if gui.question("Sair do Posta Restante?") then
		self:hide()
		eng.done()
	else
		return iup.IGNORE
	end
end

function gui.dialog:k_any(k)
	if k == iup.K_ESC then
		if gui.zbox.value == gui.new_box then
			gui.new_cancel:action()
		else
			self:close_cb()
		end
	elseif k == iup.K_DOWN and iup.GetFocus() == gui.search then
		iup.SetFocus(gui.result)
		gui.result.value = "1"
		gui.result:valuechanged_cb()
	elseif k == iup.K_UP and iup.GetFocus() == gui.result and gui.result.value == "1" then
		iup.SetFocus(gui.search)
		gui.result.value = nil
		gui.result:valuechanged_cb()
		gui.b_zbox.value = gui.icons_box
		return iup.IGNORE
	elseif k == iup.K_DEL and iup.GetFocus() == gui.result and
		gui.rtable[tonumber(gui.result.value)].NUMERO and
		gui.question("Baixar como entregue/Excluir registro?") then
		eng.delete(gui.rtable[tonumber(gui.result.value)].NUMERO)
		gui.rload()
		gui.result:valuechanged_cb()
	elseif k == iup.K_CR then
		if gui.zbox.value == gui.result_box then
			if iup.GetFocus() == gui.search and gui.menuedit.value == "ON" and not gui.search.value:find("^%s*$") then
				gui.zbox.value = gui.new_box
			elseif gui.menuedit.value == "ON" and iup.GetFocus() == gui.result then
				gui.search.value =
					gui.rtable[tonumber(gui.result.value)].NOME
				gui.zbox.value = gui.new_box
				iup.SetFocus(gui.search)
			end
		elseif gui.zbox.value == gui.new_box then
			gui.new_ok:action()
		end
	elseif k == iup.K_F2 and iup.GetFocus() == gui.result and gui.menuedit.value == "ON" then
		local number = tonumber(gui.result.value)
		local name = gui.rtable[number].NOME
		if name then
			gui.select_timer.run = "NO"
			gui.number.lastvalue = gui.number.value
			gui.number.value = gui.rtable[number].NUMERO
			gui.date.lastvalue = gui.date.value
			gui.date.value = gui.rtable[number].DATA:sub(1, 10)
			gui.search.value = name
			gui.zbox.value = gui.new_box
			iup.SetFocus(gui.search)
		end
	elseif k == iup.K_F3 then
		gui.menusearch:action()
	elseif k == iup.K_F4 then
		gui.menuedit:action()
	elseif k == iup.K_F5 then
		eng.close()
		eng.open()
	elseif k == iup.K_plus and gui.zbox.value == gui.new_box then
		gui.number.value = tonumber(gui.number.value) + 1
		return iup.IGNORE
	elseif k == iup.K_minus and gui.zbox.value == gui.new_box then
		gui.number.value = tonumber(gui.number.value) - 1
		return iup.IGNORE
	elseif k == iup.K_F10 and gui.zbox.value == gui.new_box then
		gui.lastq:action()
	elseif k == iup.K_F11 and gui.zbox.value == gui.new_box then
		gui.lastr:action()
	elseif k == iup.K_F12 and gui.zbox.value == gui.new_box then
		gui.laste:action()
	end
end

function gui.rload()
	local s = gui.search.value or ""
	if gui.menuedit.value == "ON" then s = "^" .. s end
	gui.result.removeitem = "ALL"
	gui.rtable = eng.search(s)
	gui.load_timer.run = "NO"
	gui.details.title = ""
	gui.b_zbox.value = gui.icons_box
	iup.SetIdle(gui.iload)
end

function gui.iload()
	local n = gui.result.count + 1
	if gui.rtable[n] then
		gui.result.appenditem = gui.rtable[n].NOME
		if gui.rtable[n].NUMERO <= 10000 then
			gui.result["image" .. n] = ico.email
		elseif gui.rtable[n].NUMERO <= 20000 then
			gui.result["image" .. n] = ico.newspaper
		else
			gui.result["image" .. n] = ico.bell
		end
	else
		iup.SetIdle(nil)
	end
end

function gui.search.valuechanged_cb()
	if gui.menuedit.value == "OFF" then
		gui.load_timer.run  = "NO"
	end
	gui.load_timer.run  = "YES"
end

gui.load_timer = iup.timer{
	time      = 500,
	run       = "NO",
	action_cb = gui.rload
}

function gui.result:valuechanged_cb()
	local n = tonumber(self.value)
	if n > 0 then
		gui.b_zbox.value = gui.details_box
		gui.details.title = string.format("%s - %s",
			gui.rtable[n].NUMERO,
			gui.rtable[n].DATA:sub(1, 10))
		if gui.rtable[n].DATA:sub(1, 10) <
			os.date("%Y-%m-%d", os.time()-20*24*60*60) then
			gui.details.fgcolor = "255 0 0"
		else
			gui.details.fgcolor = "0 0 0"
		end
	end
end

function gui.lastvalue()
	if gui.number.lastvalue then
		gui.number.value = gui.number.lastvalue
		gui.number.lastvalue = nil
	end
	if gui.date.lastvalue then
		gui.date.value = gui.date.lastvalue
		gui.date.lastvalue = nil
	end
end

function gui.new_cancel.action()
	gui.lastvalue()
	gui.zbox.value = gui.result_box
	gui.result.value = nil
	iup.SetFocus(gui.search)
end

function gui.new_ok.action()
	if gui.search.value and gui.search.value ~= "" then
		local i = eng.get(gui.number.value)
		if i and i.NOME then
			if gui.question(string.format(
				"O registro %s já existe, deseja substituir:\n%s?",
				gui.number.value, i.NOME)) then
				eng.delete(i.NUMERO)
			else
				return
			end
		end
		eng.new(gui.search.value, gui.number.value, gui.date.value)
		if tonumber(gui.number.value) > 0 then
			gui.number.value = gui.number.value + 1
		else
			gui.number.value = gui.number.value - 1
		end
		gui.zbox.value = gui.result_box
		gui.rload()
		iup.SetFocus(gui.search)
		gui.search.selection = "ALL"
	end
	gui.lastvalue()
end

function gui.menubutton.action()
	gui.menu:popup(iup.MOUSEPOS, iup.MOUSEPOS)
end

function gui.menusearch.action()
	gui.menuedit.value   = "OFF"
	gui.menusearch.value = "ON"
	gui.select_timer.run = "NO"
	gui.menubutton.image = ico.magnifier
	gui.zbox.value = gui.result_box
	gui.rload()
	iup.SetFocus(gui.search)
end

function gui.menuedit.action()
	gui.menusearch.value = "OFF"
	gui.menuedit.value   = "ON"
	gui.select_timer.run = "NO"
	gui.menubutton.image = ico.pencil
	gui.zbox.value = gui.result_box
	gui.rload()
	iup.SetFocus(gui.search)
end

function gui.laste.action()
	gui.number.value = eng.last()
end

function gui.lastr.action()
	local _, r = eng.last()
	gui.number.value = r
end

function gui.lastq.action()
	gui.number.value = eng.maxnumber()
end

function gui.numprev.action()
	gui.number.value = tonumber(gui.number.value) - 1
end

function gui.numnext.action()
	gui.number.value = tonumber(gui.number.value) + 1
end

function gui.dateprev.action()
	local d = { }
	d.year, d.month, d.day = gui.date.value:match('(%d%d%d%d)-(%d%d)-(%d%d)')
	if d.year and d.month and d.day then
		d.day = d.day - 1
		gui.date.value = os.date('%Y-%m-%d', os.time(d))
	else
		gui.date.value = os.date('%Y-%m-%d', os.time())
	end
end

function gui.datenext.action()
	local d = { }
	d.year, d.month, d.day = gui.date.value:match('(%d%d%d%d)-(%d%d)-(%d%d)')
	if d.year and d.month and d.day then
		d.day = d.day + 1
		gui.date.value = os.date('%Y-%m-%d', os.time(d))
	else
		gui.date.value = os.date('%Y-%m-%d', os.time())
	end
end
