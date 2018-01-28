
local luasql = require("luasql.mysql")
local cfg = require("config")


local function import()
	local start = os.clock()
	local env_sro, err = luasql.mysql()
	if not env_sro then return err end
	local con_sro, err = env_sro:connect(
		cfg.database,
		cfg.user,
		cfg.password,
		cfg.host)
	if not con_sro then return err end
	local dsuffix = os.date("%Y-%m-%d-%Hh%Mm")
	local srodata = io.open(string.format("data/srodata-%s.lua", dsuffix), "w")
	local ldidata = io.open(string.format("data/ldidata-%s.lua", dsuffix), "w")
	local objdata = io.open(string.format("data/objdata-%s.lua", dsuffix), "w")
	local csvdata = io.open(string.format("data/csvdata-%s.csv", dsuffix), "w")
	srodata:write("srodata = {\n")
	ldidata:write("ldidata = { }\n")
	objdata:write("objdata = {\n")
	local count = 1
	local ldi = { }
	local cur, err = con_sro:execute([[
		SELECT
			CUSTOMER.CS_NAME,
			LAUNCHTODLVRY.LTD_ID,
			LAUNCHTODLVRY.LTD_CREATETIME,
			LAUNCHTODLVRY.LTD_HITUNITCEP,
			LEDITEMLIST.LTD_ITEMCODE,
			LEDITEMLIST.LTD_GROUPNUMBER,
			LEDITEMLIST.LTD_LASTTIME,
			LEDITEMLIST.LTD_COMMENT,
			LEDITEMLIST.LTD_ITEMDESTINY
		FROM LEDITEMLIST
		JOIN LAUNCHTODLVRY ON
			LEDITEMLIST.EVE_ID_EVENTO = LAUNCHTODLVRY.EVE_ID_EVENTO
		LEFT JOIN CUSTOMER ON
			LEDITEMLIST.LTD_CUSTOMERCODE = CUSTOMER.CS_CODE
		LEFT JOIN
			(
				SELECT
					ADC_LISTNUMBER,
					ADC_ITEMCODE,
					ADC_STATECODE
				FROM AFTERDELIVERYCAPTURE
				JOIN ADCITEMLIST ON
					AFTERDELIVERYCAPTURE.EVE_ID_EVENTO = ADCITEMLIST.EVE_ID_EVENTO
			) AS X ON
			LEDITEMLIST.LTD_ITEMCODE = X.ADC_ITEMCODE AND
			LAUNCHTODLVRY.LTD_ID = X.ADC_LISTNUMBER
		LEFT JOIN CANCELEDITEMLIST ON
			LEDITEMLIST.LTD_ID_EVENTO = CANCELEDITEMLIST.CIL_EVEIDEVENTO
		WHERE
			LAUNCHTODLVRY.LTD_EVENTTYPECODE = 'LDI' AND
			CIL_EVEIDEVENTO IS NULL AND ADC_STATECODE IS NULL;]])
	if not cur then return err end
	if cur then
		local row = { }
		while cur:fetch(row, "a") do
			row.CS_NAME = row.CS_NAME and row.CS_NAME:upper() or ""
			row.LTD_ITEMCODE = row.LTD_ITEMCODE:upper()
			row.LTD_COMMENT = row.LTD_COMMENT:upper() or ""
			-- custom [[
			if tonumber(row.LTD_ITEMDESTINY) == 2 then
				row.OBJ_TYPE = "postal"
			elseif row.LTD_COMMENT:find("INT") then
				row.OBJ_TYPE = "intern"
			elseif row.CS_NAME:find("1%d%.?%d%d%d") or row.LTD_COMMENT:find("VOL") or row.LTD_COMMENT:find("PCTE") then
				row.OBJ_TYPE = "volume"
			elseif row.CS_NAME:find("2%d%.?%d%d%d") or (row.LTD_COMMENT:find("ENV") and row.LTD_COMMENT:find("SS")) or row.LTD_COMMENT:find("SEDEX") then
				row.OBJ_TYPE = "envsed"
			elseif row.CS_NAME:find("3%d%.?%d%d%d") or (row.LTD_COMMENT:find("ENV") and row.LTD_COMMENT:find("RE")) or row.LTD_COMMENT:find("REGISTRADO") then
				row.OBJ_TYPE = "envreg"
			else
				row.OBJ_TYPE = "outros"
			end
			-- ]]
			srodata:write("\t{\n")
			srodata:write(string.format("\t\tCS_NAME         = %q,\n", row.CS_NAME))
			srodata:write(string.format("\t\tLTD_ID          = %q,\n", row.LTD_ID))
			srodata:write(string.format("\t\tLTD_CREATETIME  = %q,\n", row.LTD_CREATETIME))
			srodata:write(string.format("\t\tLTD_HITUNITCEP  = %q,\n", row.LTD_HITUNITCEP))
			srodata:write(string.format("\t\tLTD_ITEMCODE    = %q,\n", row.LTD_ITEMCODE))
			srodata:write(string.format("\t\tLTD_GROUPNUMBER = %d,\n", row.LTD_GROUPNUMBER))
			srodata:write(string.format("\t\tLTD_LASTTIME    = %d,\n", row.LTD_LASTTIME or 0))
			srodata:write(string.format("\t\tLTD_COMMENT     = %q,\n", row.LTD_COMMENT))
			srodata:write(string.format("\t\tLTD_ITEMDESTINY = %d,\n", row.LTD_ITEMDESTINY))
			srodata:write(string.format("\t\tOBJ_TYPE        = %q,\n", row.OBJ_TYPE))
			srodata:write("\t},\n")
			if ldi[row.LTD_ID] then
				ldidata:write(string.format("table.insert(ldidata[%q], srodata[%d])\n", row.LTD_ID, count))
			else
				ldidata:write(string.format("ldidata[%q] = { srodata[%d] }\n", row.LTD_ID, count))
				ldi[row.LTD_ID] = true
			end
			objdata:write(string.format("\t[%q] = srodata[%d],\n", row.LTD_ITEMCODE, count))
			csvdata:write(string.format("%s,,%d,%s,,%s,,,,,,,,,%s,%s\n", row.LTD_ITEMCODE, row.LTD_GROUPNUMBER, row.CS_NAME, row.LTD_COMMENT, row.LTD_ID, row.OBJ_TYPE))
			count = count + 1
		end
		cur:close()
	end
	srodata:write("}\n")
	objdata:write("}\n")
	srodata:close()
	ldidata:close()
	objdata:close()
	csvdata:close()
	con_sro:close()
	env_sro:close()
	ready = io.open("data/ready.lua", "w")
	ready:write(string.format("ready = %q\n", dsuffix))
	ready:close()
	return string.format("Sincronizado em %ss.\nNo dia %s.",
		os.clock()-start, dsuffix)
end

return { import = import, server = cfg.host }
