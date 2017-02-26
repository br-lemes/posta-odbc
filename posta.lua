
os.setlocale("pt_BR")
os.setlocale("C", "numeric")

local iup = require("iuplua")
local eng = require("engine")
local gui = require("layout")
require("action")

gui.dialog:show()
eng.open()
gui.result:valuechanged_cb()
gui.number.value = eng.maxnumber()
gui.rload()
iup.MainLoop()
