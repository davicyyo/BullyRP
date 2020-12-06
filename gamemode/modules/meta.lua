local meta = FindMetaTable("Player")

if SERVER then

		function meta:getLVL()
			return self:GetPData("lvl")
		end

		function meta:getRespect(teamname)
			return self:GetPData("respect_"..teamname)
		end

		function meta:getMoney()
			return self:GetPData("money")
		end

		function meta:getStats(stats)
			if not stats then return end
			return self:GetPData("stats_"..stats)
		end

		function meta:getTeam()
			return self:GetPData("team")
		end

		function meta:getSettings(str)
			if not str then return end

			return self:GetPData("settings_"..str)
		end

		function meta:getQuest()
			return self:GetPData("quest")
		end

		function meta:getWanted()

			return self:GetNWInt("wanted")

		end

		function meta:getClass(str)
			if not str then return end

			return self:GetPData("class_"..str)

		end

		function meta:setLVL(lvl)
			if not lvl then return end

			self:SetPData("lvl",lvl)
			self:SetNWInt("lvl",lvl)

			return
		end

		function meta:setRespect(teamname,num)
			if not teamname then return end
			if not num then return end

			self:SetPData("respect_"..teamname,num)
			self:SetNWInt("respect_"..teamname,num)
			
			return
		end

		function meta:setMoney(money)
			if not money then return end

			self:SetPData("money",money)
			self:SetNWInt("money",money)
			
			return
		end

		function meta:loadData()

			local classes = {"matematicas","química","arte","geografía","biología","inglés"}

			self:SetNWInt("lvl",self:getLVL())
			self:SetNWInt("money",self:getMoney())
			self:SetNWInt("team",self:getTeam())
			self:SetNWInt("stats_misiones",self:getStats("misiones"))
			self:SetNWInt("stats_noqueados",self:getStats("noqueados"))
			self:SetNWInt("stats_progreso",self:getStats("progreso"))
			self:SetNWBool("settings_music",self:getSettings("music"))
			self:SetNWInt("wanted",0)
			for k,v in pairs(classes) do
			self:SetNWInt("class_"..v,self:getClass(v))
			end
			self:SetNWInt("quest",self:getQuest())
			for i=0,6 do
				self:setRespect(string.lower(team.GetName(i)),self:getRespect(string.lower(team.GetName(i))))
			end

			return
		end

		function meta:setStats(stats,val)
			if not stats then return end
			if not val then return end

			self:SetPData("stats_"..stats,val)
			self:SetNWInt("stats_"..stats,val)

			return
		end

		function meta:setTeam(team)
			if not team then return end

			self:SetPData("team",team)
			self:SetNWInt("team",team)
			self:setUpTeam(team)

			return
		end

		function meta:setSettings(str,val)
			if not str then return end

			self:SetPData("settings_"..str,val)
			self:SetNWBool("settings_"..str,val)

			return
		end

		function meta:sendModel(ent,model,vector,angles)
			if not ent then return end
			if not model then return end
			if not vector then return end
			if not angles then return end

			net.Start("sendModel")
			net.WriteEntity(ent)
			net.WriteString(model)
			net.WriteVector(vector)
			net.WriteAngle(angles)
			net.Send(self)

		end

		function meta:sendNotify(str)
			if not str then return end

			net.Start("_notify")
			net.WriteString(str)
			net.Send(self)

		end

		function meta:sendClass(str,num)
			if not str then return end
			if not num then return end

			net.Start("_class")
			net.WriteString(str)
			net.WriteString(num)
			net.Send(self)

		end

		function meta:sendSound(url,volume,time,boolean)
		if not url or not volume or not time or not boolean then return end


		net.Start("_sound")
		net.WriteString(url)
		net.WriteString(volume)
		net.WriteString(time)
		net.WriteBool(boolean)
		net.Send(self)


		return

		end

		function meta:removeModel()
			net.Start("removeModel")
			net.Send(self)
		end

		function meta:newQuest(str)
			if not str then return end

			net.Start("newQuest")
			net.WriteString(str)
			net.Send(self)

			self:SetPData("quest",str)
			self:SetNWInt("quest",str)

			return

		end

		function meta:setWanted(num)
			if not num then return end

			self:SetNWInt("wanted",num)

			return

		end

		function meta:classComplete(str,num)
			if not str then return end
			if not num then return end

			self:SetPData("class_"..str,num)
			self:SetNWInt("class_"..str,num)

			return

		end

		function meta:sendIcon(icon,pos)
			if not icon then return end
			if not pos then return end

			net.Start("_icon")
			net.WriteString(icon)
			net.WriteVector(pos)
			net.Send(self)

			return
		end
end

if CLIENT then

	function meta:getLVL()
		return self:GetNWInt("lvl")
	end

	function meta:getRespect(teamname)
		return self:GetNWInt("respect_"..teamname)
	end

	function meta:getMoney()
		return self:GetNWInt("money")
	end

	function meta:getTeam()
		return self:GetNWInt("team")
	end

	function meta:getStats(stats)
		if not stats then return end

		return self:GetNWInt("stats_"..stats)
	end

	function meta:getSettings(str)
		if not str then return end

		return self:GetNWBool("settings_"..str)
	end

	function meta:stopSounds()
		net.Start("stop_sounds")
		net.WriteEntity(self)
		net.SendToServer()
		return
	end

	function meta:playURL(url,volume,time,bool)
		if not url then return end
		if not volume then return end

		if self:GetNWBool("settings_music") == false then return end

		self:SetNWBool("stopsound",false)

			sound.PlayURL ( url, "noblock", function( station )
				if ( IsValid( station ) ) then

					station:SetPos( self:GetPos() )

					station:SetVolume(volume)
					station:Play()

					if time != nil then
						timer.Simple(time,function()
							if self:GetNWBool("stopsound") == true then return end
							if bool then
							station:Stop()
							self:stopSounds()
							else
							station:SetTime(0)
							end
						end)
					end

					timer.Create("think_timer",0.1,0,function()
						if self:GetNWBool("stopsound") != true then return end

						station:Stop()

						timer.Remove("think_timer")
					end)

				else

					self:ChatPrint( "Invalid URL!" )

				end
			end )

	end

	function meta:getQuest()
		return self:GetNWInt("quest")
	end

	function meta:sendNotify(str)
			if not str then return end

			_notify(str)

	end

	function meta:sendClass(str,num)
			if not str then return end
			if not num then return end

			_class(str,num)

			return

		end

	function meta:getWanted()

		return self:GetNWInt("wanted")

	end

	function meta:getClass(str)
		if not str then return end

		return self:GetNWInt("class_"..str)

	end

	function meta:isGuiEnable()
		return self:SetNWBool("guienable")
	end

	function meta:sendIcon(icon,pos)
			if not icon then return end
			if not pos then return end

			net.Start("_icon")
			net.WriteString(icon)
			net.WriteVector(pos)
			net.Send(self)

			return
		end

end