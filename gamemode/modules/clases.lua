if SERVER then
local bullyrp_clases = {"Matematicas","Ingles","Hora Libre"}

local newclass
local oldclass = "Hora Libre"
file.Write("class.txt",oldclass)
timer.Create("newClass",15,0,function()
	newclass = table.Random(bullyrp_clases)

	function writenewClass()
		newclass = table.Random(bullyrp_clases)
		if oldclass == newclass then
			writenewClass()
		else
			oldclass = newclass

			file.Write("class.txt",newclass)

			local pos = false

			local check = 0
			hook.Add("Think","checkclass",function()
				for k,v in pairs(player.GetAll()) do
					v:SetNWInt("class",newclass)
					v:sendSound("http://www.headarrow.com/media/bullyrp/effects/bell.mp3",1,9,false)
					if newclass == "Matematicas" then
						pos = Vector(-1166.790283, -491.046448, 160.031250)
					elseif newclass == "Ingles" then
						pos = Vector(1522.336426, 1336.420776, 144.031250)
					end

					if newclass != "Hora Libre" then
						if v:getClass(string.lower(newclass)) == nil then
								v:sendIcon("materials/b_bell2.png",pos,15)
						else
							if tonumber(v:getClass(string.lower(newclass))) == 5 then
								v:sendIcon("materials/b_bell.png",pos,15)
							else
								v:sendIcon("materials/b_bell2.png",pos,15)
							end
						end
					end

					if pos == false then return end

					if pos:Distance(v:GetPos()) < 400 then
						check = check + 1

						if check == 1 then
							v:SetNWInt("current",newclass)
							if tonumber(v:getClass(string.lower(newclass))) == 5 then
								v:sendClass(string.lower(newclass),5)
							else
								if v:getClass(string.lower(newclass)) == nil then
									v:sendClass(string.lower(newclass),1)
								else
									v:sendClass(string.lower(newclass),v:getClass(string.lower(newclass)) + 1)
								end
							end
						end
						if v:GetNWInt("current") != newclass then
							check = 0
						end
					end
				end
			end)


		end
	end

	if oldclass == newclass then
		writenewClass()
		newclass = table.Random(bullyrp_clases)
		return
	end

	oldclass = newclass

end)
end