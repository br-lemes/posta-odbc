
require("luasql.odbc")

eng = { }
eng.maxresult = 50
eng.mes       = {
	"Janeiro", "Fevereiro", "Março",
	"Abril",   "Maio",      "Junho",
	"Julho",   "Agosto",    "Setembro",
	"Outubro", "Novembro",  "Dezembro",
}

function eng.open_posta()
	local date = os.date("*t")
	local err
	if not eng.env_posta then
		eng.env_posta, err = luasql.odbc()
		if not eng.env_posta then
			return nil, err
		end
	end
	eng.con_posta, err = eng.env_posta:connect("POSTA")
	return eng.con_posta, err
end

function eng.close_posta()
	if eng.con_posta then eng.con_posta:close() end
	eng.con_posta = nil
end

function eng.check_options(options)
	if type(options) == "string" then
		local temp = options
		options = { }
		options.search = temp
	end
	if type(options) ~= "table" then
		options = { }
	end
	if type(options.search) == "string" then
		options.search = options.search:upper()
	else
		options.search = ""
	end
	return options
end

function eng.rawsearch_customer(options)
	options = eng.check_options(options)
	options.sby = options.sby or "2"
	local customer = { }
	function CUSTOMER(c)
		if not c.NAME or c.NAME == "" then return end
		c.ADDRESS = c.ADDRESS or ""
		local a, b
		if options.sby == "1" then
			a, b = pcall(string.find, c.NAME, options.search)
		elseif options.sby == "2" then
			a, b = pcall(string.find, c.ADDRESS, options.search)
		elseif options.sby == "3" then
			a, b = pcall(string.find, options.search, c.NAME)
		end
		if a and b then
			table.insert(customer, {NAME = c.NAME, ADDRESS = c.ADDRESS})
		end
	end
	dofile("customer.lua")
	return customer
end

function eng.rawsearch_posta(options)
	options = eng.check_options(options)
	options.sby    = options.sby    or "1"
	options.order  = options.order  or "NOME"
	options.max    = options.max    or 50
	if options.low == nil then options.low = 10000 end
	if options.high == nil then options.high = 10000 end
	local result = { }
	local cur = eng.con_posta:execute(string.format(
		"SELECT * FROM POSTA ORDER BY %s;", options.order))
	if cur then
		local row = { }
		while cur:fetch(row, "a") and #result < options.max do
			local a, b
			if options.sby == "1" then
				a, b = pcall(string.find, row.NOME, options.search)
			elseif options.sby == "3" then
				a, b = pcall(string.find, row.NUMERO, options.search)
			end
			if a and b then
				local i = {
					NOME   = row.NOME,
					NUMERO = row.NUMERO,
					DATA   = row.DATA
				}
				if options.low and i.NUMERO < options.low then
					table.insert(result, i)
				elseif options.high and i.NUMERO > options.high then
					table.insert(result, i)
				end
			end
		end
		cur:close()
	end
	return result
end

function eng.search(search)
	local r = { }
	search = search:upper()
	if eng.con_posta and (gui.femail.value == "ON" or gui.fnewspaper.value == "ON" or gui.fbell.value == "ON" or gui.menuedit.value == "ON") then
		local cur = eng.con_posta:execute("SELECT * FROM POSTA ORDER BY NOME;")
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
	if not eng.con_posta then return 0 end

	local cur = eng.con_posta:execute("SELECT MAX(NUMERO) FROM POSTA;")
	local row = { }
	cur:fetch(row)
	cur:close()
	return row[1] + 1
end

function eng.delete(n)
	n = tonumber(n)
	if not eng.con_posta then return end

	eng.con_posta:execute(string.format("DELETE FROM POSTA WHERE NUMERO=%d;", n))
end

function eng.new(name, number, date)
	number = tonumber(number)
	if not eng.con_posta then return end

	local a, m, d = date:match("(%d%d%d%d)-(%d%d)-(%d%d)")
	eng.con_posta:execute(string.format(
		"INSERT INTO POSTA VALUES ('%s', %d, '%s', %d, '%s', %d, 1);",
		name:upper(), number, date, d, eng.mes[tonumber(m)], a))
	eng.con_posta:commit()
end

function eng.get(n)
	n = tonumber(n)
	if not eng.con_posta then return end

	local cur = eng.con_posta:execute(string.format(
		"SELECT * FROM POSTA WHERE NUMERO=%d;", n))
	local row = { }
	cur:fetch(row, "a")
	cur:close()
	return row
end

function eng.minmax(d)
	if not eng.con_posta then return {min=0, max=0}, {min=0, max=0} end

	local cur = eng.con_posta:execute("SELECT * FROM POSTA;")
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
	local cur = eng.con_posta:execute(string.format(
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
	eng.con_posta:execute(string.format(
		"INSERT INTO QUANTIDADECADASTRADOS VALUES ('%d-%02d-%02d 00:00:00', '%d', '%02d', '%02d', '%s', 0, 0);",
		date.year, date.month, date.day, date.year, date.day, date.month, eng.mes[date.month]))
	eng.con_posta:commit()
end

function eng.countcad()
	local date = os.date("*t")
	local a, b = eng.todaycount()
	eng.con_posta:execute(string.format(
		"UPDATE QUANTIDADECADASTRADOS SET OBJETOSCADASTRADOS = %d WHERE ANO = '%d' AND MES = '%02d' AND DIA = '%02d';",
				a + 1, date.year, date.month, date.day))
	eng.con_posta:commit()
end

function eng.countent()
	local date = os.date("*t")
	local a, b = eng.todaycount()
	eng.con_posta:execute(string.format(
		"UPDATE QUANTIDADECADASTRADOS SET OBJETOSENTREGUES = %d WHERE ANO = '%d' AND MES = '%02d' AND DIA = '%02d';",
				b + 1, date.year, date.month, date.day))
	eng.con_posta:commit()
end

function eng.done()
	if eng.con_posta then eng.con_posta:close() end
	if eng.env_posta then eng.env_posta:close() end
end
