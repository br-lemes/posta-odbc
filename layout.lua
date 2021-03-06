
local iup = require("iuplua")
local ico = require("icons")

local gui = { }

gui.menu = iup.menu{
	radio = "YES",
	iup.item{
		name  = "menusearch",
		title = "Pesquisa\tF3",
		value = "ON",
	},
	iup.item{
		name  = "menuedit",
		title = "Edi��o\tF4",
		value = "OFF",
	},
}

gui.dialog = iup.dialog{
	rastersize = "600x440",
	title      = "Posta Restante",
	font       = "Helvetica, Bold 12",
	iup.vbox{
		margin = "10x10",
		gap    = "10",
		iup.hbox{
			margin = "0",
			iup.text{
				name       = "search",
				expand     = "HORIZONTAL",
				rastersize = "x24",
			},
			iup.button{
				name  = "menubutton",
				image = ico.magnifier,
			},
		},
		iup.zbox{
			name   = "zbox",
			margin = "0",
			iup.vbox{
				name = "result_box",
				iup.list{
					name           = "result",
					visiblelines   = "1",
					visiblecolumns = "1",
					expand         = "YES",
					showimage      = "YES",
				},
				iup.zbox{
					name       = "b_zbox",
					rastersize = "x50",
					iup.vbox{
						name = "details_box",
						iup.label{
							name      = "details",
							expand    = "HORIZONTAL",
							alignment = "ACENTER",
							title     = "\n",
						},
					},
					iup.vbox{
						name = "icons_box",
						iup.fill{},
						iup.hbox{
							iup.fill{},
							iup.toggle{
								name   = "femail",
								image  = ico.mail_white,
								value  = "ON",
								tip    = "Envelope (0 a 10000)",
								action = function () gui.rload() end,
							},
							iup.toggle{
								name   = "fnewspaper",
								image  = ico.newspaper,
								value  = "ON",
								tip    = "Revista (10001 a 20000)",
								action = function () gui.rload() end,
							},
							iup.toggle{
								name   = "fbell",
								image  = ico.bell,
								value  = "ON",
								tip    = "Aviso (acima de 20001)",
								action = function () gui.rload() end,
								active = "YES",
							},
							iup.fill{},
						},
						iup.fill{},
					},
				},
			},
			iup.vbox{
				name = "new_box",
				iup.vbox{
					iup.hbox{
						iup.button{
							name  = "numprev",
							tip   = "-",
							image = ico.book_previous,
						},
						iup.text{
							name       = "number",
							rastersize = "100",
							mask       = "[+/-]?/d+",
						},
						iup.button{
							name  = "numnext",
							tip   = "+",
							image = ico.book_next,
						},
						iup.fill{rastersize="16"},
						iup.button{
							name  = "laste",
							tip   = "F12",
							image = ico.mail_white,
						},
						iup.button{
							name  = "lastr",
							tip   = "F11",
							image = ico.newspaper,
						},
						iup.button{
							name  = "lastq",
							tip   = "F10",
							image = ico.bell,
						},
						iup.fill{},
					},
					iup.hbox{
						iup.button{
							name  = "dateprev",
							image = ico.date_previous,
						},
						iup.text{
							name       = "date",
							rastersize = "100",
							value      = os.date("%Y-%m-%d"),
							mask       = "20/d/d-/d/d-/d/d",
						},
						iup.button{
							name  = "datenext",
							image = ico.date_next,
						},
						iup.fill{},
						iup.button{
							name   = "new_cancel",
							title  = " Cancelar ",
							tip    = "ESC",
						},
						iup.button{
							name   = "new_ok",
							title  = " OK ",
							tip    = "ENTER",
						},
					},
				},
			},
		},
	},
}

function gui.iupnames(self, elem)
	if type(elem) == "userdata" then
		if elem.name ~= "" and elem.name ~= nil then
			self[elem.name] = elem
		end
	end
	local i = 1
	while elem[i] do
		self:iupnames(elem[i])
		i = i + 1
	end
end

gui:iupnames(gui.dialog)
gui:iupnames(gui.menu)

return gui
