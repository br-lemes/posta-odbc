
local luasql = require("luasql.odbc")
local gui = require("layout")

local eng = { }
eng.maxresult = 50
eng.mes       = {
	"Janeiro", "Fevereiro", "Março",
	"Abril",   "Maio",      "Junho",
	"Julho",   "Agosto",    "Setembro",
	"Outubro", "Novembro",  "Dezembro",
}

local function engerr(err)
	local msg = "Erro de conexão com banco de dados. Pressione F5 para atualizar."
	if err then msg = string.format("%s\nSe o problema persistir, peça ajuda com a mensagem abaixo:\n%s", msg, err) end
	iup.Message("Erro", msg)
end

function eng.open()
	local err
	if not eng.env then
		eng.env, err = luasql.odbc()
		if not eng.env then
			engerr(err)
			return nil, err
		end
	end
	eng.con, err = eng.env:connect("POSTA")
	if not eng.con then
		engerr(err)
		return nil, err
	end
	return eng.con
end

function eng.close()
	if eng.con then eng.con:close() end
	eng.con = nil
end

function eng.search(search)
	local r = { }
	search = search:upper()
	if eng.con and (gui.femail.value == "ON" or gui.fnewspaper.value == "ON" or gui.fbell.value == "ON" or gui.menuedit.value == "ON") then
		local cur = eng.con:execute("SELECT * FROM POSTA ORDER BY NOME;")
		if cur then
			local row = { }
			while cur:fetch(row, "a") and #r < eng.maxresult do
				local a, b = pcall(string.find, row.NOME, search)
				if a and b then
					local i = {
						NOME   = row.NOME,
						NUMERO = tonumber(row.NUMERO),
						DATA   = row.DATA
					}
					if i.NUMERO > 0 and i.NUMERO <= 10000 and gui.femail.value == "ON" then
						table.insert(r, i)
					elseif i.NUMERO > 10000 and i.NUMERO <= 20000 and gui.fnewspaper.value == "ON" then
						table.insert(r, i)
					elseif i.NUMERO > 20000 and gui.fbell.value == "ON" then
						table.insert(r, i)
					end
				end
			end
			cur:close()
		end
	end
	return r
end

function eng.maxnumber()
	if not eng.con then return 0 end

	local cur = eng.con:execute("SELECT MAX(NUMERO) FROM POSTA;")
	local row = { }
	cur:fetch(row)
	cur:close()
	return row[1] + 1
end

function eng.delete(n)
	n = tonumber(n)
	if not eng.con then return end

	eng.con:execute(string.format("DELETE FROM POSTA WHERE NUMERO=%d;", n))
end

function eng.new(name, number, date)
	number = tonumber(number)
	if not eng.con then return end

	local a, m, d = date:match("(%d%d%d%d)-(%d%d)-(%d%d)")
	eng.con:execute(string.format(
		"INSERT INTO POSTA VALUES ('%s', %d, '%s', %d, '%s', %d, 1);",
		name:upper(), number, date, d, eng.mes[tonumber(m)], a))
	eng.con:commit()
end

function eng.get(n)
	n = tonumber(n)
	if not eng.con then return end

	local cur = eng.con:execute(string.format(
		"SELECT * FROM POSTA WHERE NUMERO=%d;", n))
	local row = { }
	cur:fetch(row, "a")
	cur:close()
	return row
end

function eng.minmax(d)
	if not eng.con then return {min=0, max=0}, {min=0, max=0} end

	local cur = eng.con:execute("SELECT * FROM POSTA;")
	local row = { }
	local e = { }
	local r = { }
	e.min = 999999
	e.max = 0
	r.min = 999999
	r.max = 0
	while cur:fetch(row, "a") do
		if row.NUMERO > 0 and row.NUMERO <= 10000 and row.DATA == d then
			e.max = math.max(e.max, row.NUMERO)
			e.min = math.min(e.min, row.NUMERO)
		elseif row.NUMERO > 10000 and row.NUMERO <= 20000 and row.DATA == d then
			r.max = math.max(r.max, row.NUMERO)
			r.min = math.min(r.min, row.NUMERO)
		end
	end
	cur:close()
	if e.min == 999999 then e.min = 0 end
	if r.min == 999999 then r.min = 0 end
	return e, r
end

function eng.last()
	local e, r = eng.minmax(os.date("%Y-%m-%d") .. " 00:00:00")
	local i = 1
	while e.max == 0 or r.max == 0 do
		local tmpe, tmpr = eng.minmax(os.date("%Y-%m-%d", os.time()-i*24*60*60) .. " 00:00:00")
		if e.max == 0 then e.max = tmpe.max end
		if r.max == 0 then r.max = tmpr.max end
		i = i + 1
	end
	return e.max + 1, r.max + 1
end

function eng.todaycount()
	local date = os.date("*t")
	local cur = eng.con:execute(string.format(
		"SELECT OBJETOSCADASTRADOS, OBJETOSENTREGUES FROM QUANTIDADECADASTRADOS WHERE ANO = '%d' AND MES = '%02d' AND DIA = '%02d';",
		date.year, date.month, date.day))
	local row = { }
	cur:fetch(row)
	cur:close()
	if row[1] == nil then
		eng.startcount()
		return 0, 0
	end
	return row[1], row[2]
end

function eng.startcount()
	local date = os.date("*t")
	eng.con:execute(string.format(
		"INSERT INTO QUANTIDADECADASTRADOS VALUES ('%d-%02d-%02d 00:00:00', '%d', '%02d', '%02d', '%s', 0, 0);",
		date.year, date.month, date.day, date.year, date.day, date.month, eng.mes[date.month]))
	eng.con:commit()
end

function eng.countcad()
	local date = os.date("*t")
	local a = eng.todaycount()
	eng.con:execute(string.format(
		"UPDATE QUANTIDADECADASTRADOS SET OBJETOSCADASTRADOS = %d WHERE ANO = '%d' AND MES = '%02d' AND DIA = '%02d';",
				a + 1, date.year, date.month, date.day))
	eng.con:commit()
end

function eng.countent()
	local date = os.date("*t")
	local _, b = eng.todaycount()
	eng.con:execute(string.format(
		"UPDATE QUANTIDADECADASTRADOS SET OBJETOSENTREGUES = %d WHERE ANO = '%d' AND MES = '%02d' AND DIA = '%02d';",
				b + 1, date.year, date.month, date.day))
	eng.con:commit()
end

function eng.done()
	if eng.con then eng.con:close() end
	if eng.env then eng.env:close() end
end

return eng
