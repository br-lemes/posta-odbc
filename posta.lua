
os.setlocale("pt_BR")
os.setlocale("C", "numeric")

gui = { }

require("iuplua")
require("luasql.odbc")
require("icons")
require("engine")
require("layout")
require("action")

gui.dialog:show()
local con, err = eng.open_posta()
if not con then	iup.Message("Erro", err) end
gui.result:valuechanged_cb()
gui.number.value = eng.maxnumber()
gui.rload()
iup.MainLoop()
