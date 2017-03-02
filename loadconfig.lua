
local validengine = { odbc = true, sqlite3 = true }
local fun = loadfile("config.lua", "t", { })
local ok, cfg = pcall(fun)
if not ok then cfg = { } end
if not validengine[cfg.engine] then cfg.engine = "sqlite3" end
if not cfg.objnum or cfg.objnum < 1000 or cfg.objnum > 1000000 or cfg.objnum % 100 ~= 0 then
	cfg.objnum = 100000
end
for _,v in ipairs(cfg) do
	v.nome  = v.nome  or ""
	v.icone = v.icone or "mail_white"
	v.prazo = v.prazo or 20
end
return cfg
