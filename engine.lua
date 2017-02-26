
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

function eng.last(min, max)
	if not eng.con then return 0 end

	local cur, err = eng.con:execute(string.format(
		"SELECT MAX(NUMERO) FROM POSTA WHERE DATA IN (SELECT MAX(DATA) FROM POSTA WHERE NUMERO>%d AND NUMERO<%d) AND NUMERO>%d AND NUMERO<%d;",
		min, max, min, max))
	local row = { }
	cur:fetch(row)
	cur:close()
	return row[1] + 1 or 0
end

function eng.done()
	if eng.con then eng.con:close() end
	if eng.env then eng.env:close() end
end

return eng
