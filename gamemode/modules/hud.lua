if CLIENT then

local namedversion = "PRE-ALPHA"
local version = "0.0.1"

local Escape_Openned = false
function mainDerma()
		local dfr = vgui.Create("DFrame")
		dfr:SetSize(ScrW(),ScrH())
		dfr:SetPos(0,0)
		dfr:SetTitle("")
		dfr:ShowCloseButton(false)
		dfr:SetDraggable(false)
		dfr:MakePopup()
		dfr.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(18,48,83))
		end

		function mainDermaRemove()
			if not IsValid(dfr) then return end
			dfr:AlphaTo(0,1,0,function()
				dfr:Remove()
				LocalPlayer():SetNWBool("stopsound",true)
			end)
		end

		local dimg = vgui.Create("DHTML",dfr)
		dimg:SetSize(dfr:GetWide(),dfr:GetTall())
		dimg:SetPos(dfr:GetWide()*0,dfr:GetTall()*0)
		dimg:SetMouseInputEnabled(false)
		dimg:SetHTML([[
			<img src="https://i.imgur.com/w9mYPE6.png" height="300" width="600"/>
		]])
		dimg.Paint = function(self,w,h)
		draw.SimpleText(namedversion,"F_Normal",w*0.06,h*0.265,Color(247,173,41,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("V."..version,"F_Normal",w*0.22,h*0.265,Color(247,173,41,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end

		local l = vgui.Create( "DIconLayout", dfr )
		l:SetSize(dfr:GetWide()*0.215,dfr:GetTall())
		l:SetPos(dfr:GetWide()*0.05,dfr:GetTall()*0.35)
		l:SetSpaceY( 5 )
		l:SetSpaceX( 5 )


		local models = {
		"models/player/bully/bif/bif.mdl",
		"models/player/bully/bucky/bucky.mdl",
		"models/player/bully/davis/davis.mdl",
		"models/player/bully/casey/casey.mdl",
		"models/player/bully/damon/damon.mdl",
		"models/player/bully/chad/chad.mdl",
		"models/player/bully/bryce/bryce.mdl",
		"models/player/bully/constantinos/constantinos.mdl",
		"models/player/bully/cornelius/cornelius.mdl",
		"models/player/bully/derby/derby.mdl",
		"models/player/bully/gord/gord.mdl",
		"models/player/bully/earnest/earnest.mdl",
		"models/player/bully/gordon/gordon.mdl",
		"models/player/bully/hal/hal.mdl",
		"models/player/bully/ivan/ivan.mdl",
		"models/player/bully/johnny/johnny.mdl",

		}

		local icon = vgui.Create( "DModelPanel", dfr )
		icon:SetSize( dfr:GetWide()*4,dfr:GetTall()*4 )
		icon:SetPos( dfr:GetWide()*0.3,dfr:GetTall()*0.1 )
		icon:SetMouseInputEnabled(false)
		icon:SetModel( table.Random(models) )
		icon:SetFOV(60)
		icon:SetCamPos(Vector(60,40,80))
		icon:SetLookAt(icon:GetLookAt() + Vector(0,0,12))
		function icon:LayoutEntity( Entity ) return end

		
		if Escape_Openned then
			LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/music/theme.mp3",0.1,240,true)
		end

		local buttons = {
		{n="NUEVA PARTIDA"},
		{n="CARGAR PARTIDA"},
		{n="MIS STATS"},
		{n="PÁGINA WEB"},
		{n="SERVIDORES"},
		{n="DESCONECTARSE"},
		}

		local derma_loaded = false
		function loadPanel(number)


			if number == 2 then
				if LocalPlayer():getLVL() == "nil" then return end
				if tonumber(LocalPlayer():getLVL()) <= 1 then return end
				net.Start("loadgame")
				net.WriteEntity(LocalPlayer())
				net.SendToServer()
				dfr:AlphaTo(0,1,0,function()
					dfr:Remove()
				end)

				LocalPlayer():stopSounds()
				return
			end

			if number == 3 then
				if LocalPlayer():getLVL() == "nil" then return end
				if tonumber(LocalPlayer():getLVL()) <= 1 then return end
			end

			if number == 4 then
				gui.OpenURL("https://www.servers.headarrow.com/bullyrp")
				return
			end

			if IsValid(icon) then
				icon:MoveTo(dfr:GetWide()*1,dfr:GetTall()*0.1,1,0,-1,function()
					if not IsValid(icon) then return end
					icon:Remove()
				end)
			end

			local b

			for k,v in pairs(buttons) do
				if k == number then
					b = v.n
				end
			end


			if derma_loaded then removederma() end

			local screen = vgui.Create("DFrame",dfr)
			screen:SetSize(dfr:GetWide()*0.68,dfr:GetTall()*0.88)
			screen:SetPos(dfr:GetWide()*1,dfr:GetTall()*0.1)
			screen:SetTitle("")
			screen:MoveTo(dfr:GetWide()*0.3,dfr:GetTall()*0.1,1,1)
			screen:ShowCloseButton(false)
			screen:SetDraggable(false)
			screen.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
				surface.SetDrawColor(18,48,83)
				surface.DrawRect(w*0.002,w*0.002,w*0.997,h*0.996)
				draw.SimpleText(b,"F_Enorme",w*0.02,h*0.02,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				if number == 1 then
				draw.SimpleText("¿Estás seguro que quieres crear una nueva partida?","F_Enorme",w*0.05,h*0.3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				draw.SimpleText("Si tu partida existe se perderá","F_Enorme",w*0.25,h*0.8,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				end
			end

			if number == 1 then
			local butt = vgui.Create("DButton",screen)
			butt:SetSize(screen:GetWide()*0.4,screen:GetTall()*0.2)
			butt:CenterHorizontal(0.5)
			butt:CenterVertical(0.6)
			butt:SetText("CONTINUAR")
			butt:SetFont("F_Grande")
			butt.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end

			butt.DoClick = function()
				butt:Remove()
				dfr:AlphaTo(0,1,0,function()
					dfr:Remove()
				end)
				net.Start("newgame")
				net.WriteEntity(LocalPlayer())
				net.SendToServer()
				LocalPlayer():stopSounds()
			end

			end

			if number == 3 then
				local List = vgui.Create( "DIconLayout", screen )
				List:SetSize(screen:GetWide()*0.9,screen:GetTall()*0.3)
				List:SetPos(screen:GetWide()*0.05,screen:GetTall()*0.15)
				List:SetSpaceY( 5 )
				List:SetSpaceX( 5 )

				for i=1,11 do
					local butt = List:Add("DButton")
					butt:SetSize(List:GetWide(),List:GetTall()*0.2)
					butt:SetPos(List:GetWide()*0,List:GetTall()*0)
					if i == 1 then
						butt:SetText(LocalPlayer():Nick().." ")
					elseif i == 2 then
						butt:SetText(LocalPlayer():getRespect("abusones").."%  ")
					elseif i == 3 then
						butt:SetText(LocalPlayer():getRespect("macarras").."%  ")
					elseif i == 4 then
						butt:SetText(LocalPlayer():getRespect("empollones").."%  ")
					elseif i == 5 then
						butt:SetText(LocalPlayer():getRespect("musculitos").."%  ")
					elseif i == 6 then
						butt:SetText(LocalPlayer():getRespect("pijos").."%  ")
					elseif i == 7 then
						butt:SetText(LocalPlayer():getStats("misiones").."  ")
					elseif i == 8 then
						butt:SetText(LocalPlayer():getStats("ogreso").."%   ")
					elseif i == 9 then
						butt:SetText(math.Round(LocalPlayer():getStats("tiempo")/3600,1).." Horas   ")
					elseif i == 10 then
						butt:SetText(LocalPlayer():getStats("noqueados").." Alumnos   ")
					elseif i == 11 then
						butt:SetText(LocalPlayer():getLVL().."   ")
					end
					butt:SetContentAlignment(6)
					butt:SetMouseInputEnabled(false)
					butt:SetFont("F_Grande")
					butt.Paint = function(self,w,h)
						draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
						if i == 1 then
							draw.SimpleText("NOMBRE:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 2 then
							draw.SimpleText("RESPETO ABUSONES:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 3 then
							draw.SimpleText("RESPETO MACARRAS:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 4 then
							draw.SimpleText("RESPETO EMPOLLONES:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 5 then
							draw.SimpleText("RESPETO MUSCULITOS:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 6 then
							draw.SimpleText("RESPETO PIJOS:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 7 then
							draw.SimpleText("MISIONES COMPLETADAS:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 8 then
							draw.SimpleText("PROGRESO:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 9 then
							draw.SimpleText("TIEMPO JUGADO:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 10 then
							draw.SimpleText("IA NOQUEADA:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						elseif i == 11 then
							draw.SimpleText("NIVEL ACTUAL:","F_Normal",w*0.01,h*0.2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
						end
					end
				end
			end

			if number == 5 then
				local List = vgui.Create( "DIconLayout", screen )
				List:SetSize(screen:GetWide()*0.9,screen:GetTall()*0.3)
				List:SetPos(screen:GetWide()*0.05,screen:GetTall()*0.15)
				List:SetSpaceY( 5 )
				List:SetSpaceX( 5 )

				local svs = {
					{n="HogwartsRP",ip="hogwartsrp.headarrow.com"},
					{n="NightZ",ip="nightz.headarrow.com"},
				}

				for k,v in pairs(svs) do
				local svframe = List:Add("DFrame")
				svframe:SetSize(List:GetWide(),List:GetTall())
				svframe:SetPos(List:GetWide()*0,List:GetTall()*0)
				svframe:SetTitle("")
				svframe:ShowCloseButton(false)
				svframe:SetDraggable(false)
				svframe.Paint = function(self,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
					surface.SetDrawColor(18,48,83)
					surface.DrawRect(w*0.002,w*0.002,w*0.997,h*0.99)
					draw.SimpleText(v.n,"F_Enorme",w*0.025,h*0.2,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
					draw.SimpleText(v.ip,"F_Normal",w*0.025,h*0.6,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				end
				end

			end

			if number == 6 then
			local butt = vgui.Create("DButton",screen)
			butt:SetSize(screen:GetWide()*0.4,screen:GetTall()*0.2)
			butt:Center()
			butt:SetText("PRESIONE DE NUEVO")
			butt:SetFont("F_Grande")
			butt.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end

			butt.DoClick = function()
				LocalPlayer():ConCommand("disconnect")
			end

			end

			function removederma()
				screen:MoveTo(dfr:GetWide()*1,dfr:GetTall()*0.1,1,0,-1,function()
					screen:Remove()
				end)
			end



			derma_loaded = true


		end

		dfr.OnClose = function()
		LocalPlayer():SetNWBool("stopsound",true)
		end

		for k,v in pairs(buttons) do
			local played=false
			local b = l:Add("DButton")
			b:SetSize(l:GetWide(),l:GetTall()*0.1)
			b:SetPos(l:GetWide()*0,l:GetTall()*0)
			b:SetText(v.n)
			b:SetFont("F_Grande")
			b.Paint = function(self,w,h)
				if v.bH then
					if played then
						played=false
					end
					draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
					b:SetColor(Color(18,48,83))
				else
					if played==false then
						--LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/hover.wav",1)
						played=true
					end
					draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
					surface.SetDrawColor(18,48,83)
					surface.DrawRect(w*0.01,w*0.01,w*0.985,h*0.915)
					b:SetColor(Color(247,173,41))
				end
			end

			b.OnCursorEntered = function()
				v.bH = true
			end

			b.OnCursorExited = function()
				v.bH = false
			end

			b.DoClick = function()
				loadPanel(k)
				LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/click.wav",0.5)
			end

		end
end

net.Receive("D_main",mainDerma)

local Escape_Openned = false
hook.Add("PreRender", "PreRender", function()
	if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() and !IsValid(dfr) then
		if LocalPlayer():GetNWBool("guienable") then return end
		if Escape_Openned then
			gui.HideGameUI()
			mainDermaRemove()
			Escape_Openned = false
		else
			gui.HideGameUI()
			mainDerma()
			Escape_Openned = true
		end
	end
end)
local miniMap
--timer.Simple( 5, function() Solo en DEV
--	miniMap:Remove()
--	miniMap = nil
--end )

hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
	if not LocalPlayer():Alive() then return end
	local w, h = ScrW()/6, ScrH()/3

	surface.SetDrawColor( 18,48,83, 255 )
	surface.DrawRect( ScrW()-w-25, 30, w, h )

	surface.DrawRect( ScrW()-w-25, 35+h, w, h/8 )

	surface.SetDrawColor( 25,25,25 )

	surface.DrawRect( ScrW()-w-20, 35, w-10, h*0.75 )


	surface.SetDrawColor( 247,173,41 )
	surface.DrawRect( ScrW()-w-20, 40+h, (w-10)/100*(LocalPlayer():Health() < LocalPlayer():GetMaxHealth() and LocalPlayer():GetMaxHealth()/100*LocalPlayer():Health() or 100), h/8-10 )

	surface.SetFont( "F_Grande" )
	surface.SetTextColor( 255, 255, 255, 255 )
	if LocalPlayer():Health() >= 100 and LocalPlayer():Health() < 999 then
	surface.SetTextPos( ScrW()*0.885,ScrH()*0.3725 )
	elseif LocalPlayer():Health() >= 10 and LocalPlayer():Health() < 99 then
	surface.SetTextPos( ScrW()*0.89,ScrH()*0.3725 )
	elseif LocalPlayer():Health() >= 1 and LocalPlayer():Health() < 9 then
	surface.SetTextPos( ScrW()*0.9,ScrH()*0.3725 )
	end
	surface.DrawText( LocalPlayer():Health().."%" )

	surface.SetFont( "F_Mini" )
	surface.SetTextColor( 215,216,217, 255 )
	local actual_class = string.upper(  LocalPlayer():GetNWInt("class") )
	surface.SetTextPos( ScrW()-w-20, 37.5+h*0.75 )
	surface.DrawText( "CLASE ACTUAL:" )
	
	surface.SetTextColor( 247, 173, 41 )
	surface.SetFont( "F_Grande" )
	local width, height = surface.GetTextSize( actual_class )
	surface.SetTextPos( ScrW()-w/2-25-width/2, h*0.75+h*0.185 )
	surface.DrawText( actual_class )

	if miniMap then return end
	miniMap = vgui.Create( "DFrame" )
	miniMap:SetPos( ScrW()-w-20, 35 )
	miniMap:SetSize( w-10, h*0.75 )
	miniMap:ShowCloseButton( false )
	miniMap:SetTitle( "" )
	function miniMap:Paint( w, h )
		if gui.IsConsoleVisible() or gui.IsGameUIVisible() or LocalPlayer():GetNWBool("guienable") or vgui.CursorVisible() then return end
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( Material("minimap/bully_simplificado.png") )
		surface.DrawTexturedRectRotated( w/2-LocalPlayer():GetPos()[1]/18, h/2-390+LocalPlayer():GetPos()[2]/10, 1200, 1800, -0.15 )	
		surface.SetDrawColor( 247,173,41 )
		surface.SetMaterial( Material("minimap/arrow.png") )
		surface.DrawTexturedRectRotated( w/2, h/2, 17, 17, LocalPlayer():GetAngles()[2]-90 )
	end
end )

	function newQuest(str)
		local w = surface.GetTextSize(str)
		local totalW = w*(ScrW()/1000.9)

		if totalW < ScrW()*0.15 then
			totalW = ScrW()*0.15
		end

		if totalW > ScrW()*0.9 then
			totalW = ScrW()*0.9
		end

		if LocalPlayer():GetNWBool("IsShowing:Quest") then
			removeDB()
		end

		LocalPlayer():SetNWBool("IsShowing:Quest",true)

		local db = vgui.Create("DButton")
		db:SetSize(ScrW()*-1,ScrH()*0.1)
		db:SizeTo(totalW,ScrH()*0.1,1)
		db:SetPos(ScrW()*0.01,ScrH()*0.1)
		db:SetText("")
		db.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			draw.SimpleText("OBJETIVO ACTUAL","F_Mini+",w*0.01,h*0.01,Color(18,48,83),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			surface.SetDrawColor(18,48,83)
			surface.DrawRect(w*0.03,h*0.3,w*0.95,h*0.625)
			draw.SimpleText(string.upper(str),"F_Normal",w*0.05,h*0.45,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end


		function removeDB()
			db:Remove()
		end
	end

net.Receive("newQuest",function()
	local msg = net.ReadString()
	newQuest(msg)
end)

function _notify(str)
	notification.AddLegacy( str, NOTIFY_GENERIC, 5 )
	surface.PlaySound( "buttons/button18.wav" )
end

net.Receive("_notify",function()
	local msg = net.ReadString()

	_notify(msg)

end)

function _class(str,num)
	local values = {1,2,3,4,5}
	if LocalPlayer():GetNWBool("guienable") == true then return end

	function mathsClass(val)
		if not table.HasValue(values,tonumber(val)) then return end

		local options = {}
		local need
		local aciertos = 0
		local question = 0
		local time

		if tonumber(val) == 1 then
			time = 1.3
			need = 13
			options = {

			[1] = {q="4+3 = ?",a="7",o1="7",o2="1",o3="8"},
			[2] = {q="¿Qué es más veloz?",a="Cohete",o1="Lince",o2="Cohete",o3="Tortuga"},
			[3] = {q="7/7 = ?",a="1",o1="7",o2="1",o3="0"},
			[4] = {q="8-8 = ?",a="0",o1="0",o2="8",o3="1"},
			[5] = {q="¿Qué es más alto?",a="Jirafa",o1="Jirafa",o2="Elefante",o3="Chimpancé"},
			[6] = {q="5+5-3 = ?",a="7",o1="7",o2="10",o3="4"},
			[7] = {q="?+3 = 8",a="5",o1="5",o2="3",o3="8"},
			[8] = {q="3*3+1 = ?",a="10",o1="12",o2="10",o3="9"},
			[9] = {q="¿Qué es más agresivo?",a="León",o1="León",o2="Chimpancé",o3="Jirafa"},
			[10] = {q="¿Cuántos grados tiene una circunferencia?",a="360º",o1="180º",o2="360º",o3="120º"},
			[11] = {q="4+4+3 = ?",a="11",o1="12",o2="11",o3="10"},
			[12] = {q="¿Cuantos cuadrados tiene un círculo?",a="0",o1="1",o2="4",o3="0"},
			[13] = {q="¿Qué es más grande?",a="Rinoceronte",o1="Hormiga",o2="Gato",o3="Rinoceronte"},
			[14] = {q="8-8+? = 1",a="1",o1="8",o2="1",o3="0"},
			[15] = {q="2+2+3+5 = ?",a="12",o1="12",o2="13",o3="9"},
			[16] = {q="¿Qué es más veloz?",a="Kart",o1="Bicicleta",o2="Tanque",o3="Kart"},
			[17] = {q="¿Cuál pone huevos?",a="Todas",o1="Gorriones",o2="Cigüeñas",o3="Todas"},
			[18] = {q="3+5-1 = ?",a="7",o1="4",o2="8",o3="7"},
			[19] = {q="4+4+4 = ?",a="12",o1="8",o2="12",o3="9"},
			[20] = {q="¿Qué es el H2O?",a="Agua",o1="Oxígeno",o2="Carbono",o3="Agua"},

			}

		elseif tonumber(val) == 2 then
			time = 1.2
			need = 14
			options = {

			[1] = {q="4*3 = ?",a="12",o1="9",o2="12",o3="24"},
			[2] = {q="¿Qué es más veloz?",a="Coche",o1="Bicicleta",o2="Patinete",o3="Coche"},
			[3] = {q="1/2 = ?",a="0'5",o1="1",o2="2",o3="0'5"},
			[4] = {q="2+6 = ?",a="8",o1="5",o2="2",o3="8"},
			[5] = {q="¿Qué es más alto?",a="Farola",o1="Farola",o2="Mono",o3="Caballo"},
			[6] = {q="8+1-3 = ?",a="6",o1="6",o2="4",o3="5"},
			[7] = {q="?*3 = 3",a="1",o1="3",o2="1",o3="9"},
			[8] = {q="6*5+1 = ?",a="31",o1="24",o2="21",o3="31"},
			[9] = {q="¿Qué es más venenoso?",a="Viuda negra",o1="León",o2="Murciélago",o3="Viuda negra"},
			[10] = {q="¿Cuántos grados tiene media circunferencia?",a="180º",o1="180º",o2="360º",o3="120º"},
			[11] = {q="4*4+3 = ?",a="19",o1="17",o2="19",o3="18"},
			[12] = {q="¿Cuantos lados tiene un cuadrado?",a="4",o1="4",o2="2",o3="3"},
			[13] = {q="¿Qué es más grande?",a="Tanque",o1="Hormiga",o2="Caballo",o3="Tanque"},
			[14] = {q="8/8-? = 0",a="1",o1="1",o2="8",o3="0"},
			[15] = {q="4+4-2*3 = ?",a="2",o1="4",o2="2",o3="3"},
			[16] = {q="¿Qué es más veloz?",a="Caza",o1="Coche",o2="Lince",o3="Caza"},
			[17] = {q="4+3-7 = ?",a="0",o1="12",o2="0",o3="3"},
			[18] = {q="1+1 = ?",a="2",o1="7",o2="1",o3="2"},
			[19] = {q="3*2+? = 10",a="4",o1="2",o2="4",o3="1"},
			[20] = {q="¿Qué es el CO2?",a="Dióxido de Carbono",o1="Carbono",o2="Dióxido de Carbono",o3="Oxígeno"},

			}

		elseif tonumber(val) == 3 then
			time = 1.1
			need = 15
			options = {

			[1] = {q="1/3 = ?",a="0.3",o1="1",o2="0.3",o3="2"},
			[2] = {q="¿Qué es más pequeño?",a="Molécula",o1="Mosquito",o2="Hormiga",o3="Molécula"},
			[3] = {q="1/? = 0'5",a="2",o1="2",o2="0.25",o3="1/3"},
			[4] = {q="4-3 = ?",a="1",o1="2",o2="1",o3="4"},
			[5] = {q="¿Qué está más lejos?",a="Luna",o1="Nueva York",o2="Australia",o3="Luna"},
			[6] = {q="8*1+3 = ?",a="11",o1="11",o2="4",o3="13"},
			[7] = {q="?*6 = 36",a="6",o1="3",o2="6",o3="4"},
			[8] = {q="¿el 50% de 100 es?",a="50",o1="100",o2="50%",o3="50"},
			[9] = {q="¿Qué es más venenoso?",a="Viuda negra",o1="Mamba negra",o2="Pitón",o3="Viuda negra"},
			[10] = {q="12*3 = ?",a="36",o1="36",o2="24",o3="12"},
			[11] = {q="5+5*2 = ?",a="15",o1="20",o2="10",o3="15"},
			[12] = {q="√25 = ?",a="5",o1="25",o2="5",o3="1"},
			[13] = {q="¿Qué es más grande?",a="Aeropuerto",o1="Tanque",o2="Barco",o3="Aeropuerto"},
			[14] = {q="¿Cuantos lados tiene un Hexágono?",a="6",o1="5",o2="6",o3="8"},
			[15] = {q="4*4-3*2 = ?",a="10",o1="10",o2="4",o3="8"},
			[16] = {q="¿Qué es más veloz?",a="Leopardo",o1="Perro",o2="Leopardo",o3="Tigre"},
			[17] = {q="6+6*2 = ?",a="24",o1="12",o2="30",o3="24"},
			[18] = {q="4/4+4 = ?",a="5",o1="0",o2="5",o3="4"},
			[19] = {q="50*10 = ?",a="500",o1="130",o2="500",o3="150"},
			[20] = {q="¿Qué es el 2C en una composición?",a="2 Carbonos",o1="2 Carburos",o2="2 Carbonato Cálcico",o3="2 Carbonos"},

			}
		elseif tonumber(val) == 4 then
			time = 1
			need = 16
			options = {

			[1] = {q="0'5*2 = ?",a="1",o1="2",o2="0.95",o3="1"},
			[2] = {q="¿Qué es más pequeño?",a="Átomo",o1="Átomo",o2="Molécula",o3="Célula"},
			[3] = {q="1/? = 0'3",a="3",o1="3",o2="1/3",o3="2"},
			[4] = {q="1/2-0'5 = ?",a="0",o1="1",o2="0.25",o3="0"},
			[5] = {q="¿Qué está más lejos?",a="Sol",o1="Coche tesla",o2="Sol",o3="Luna"},
			[6] = {q="8*1+1-1 = ?",a="8",o1="8",o2="7",o3="9"},
			[7] = {q="?*9 = 72",a="8",o1="9",o2="8",o3="7"},
			[8] = {q="¿el 25% de 100 es?",a="25",o1="30",o2="25%",o3="25"},
			[9] = {q="¿Qué es más grande?",a="Dinosaurio",o1="Rinoceronte",o2="Dinosaurio",o3="Megalodón"},
			[10] = {q="12*8 = ?",a="96",o1="76",o2="96",o3="84"},
			[11] = {q="5+10*2 = ?",a="30",o1="20",o2="5",o3="30"},
			[12] = {q="√36 = ?",a="6",o1="33",o2="6",o3="12"},
			[13] = {q="¿Qué es más poderoso?",a="Estados Unidos",o1="Estados Unidos",o2="Alemania",o3="Japón"},
			[14] = {q="¿Cuantos lados tiene un Octógono?",a="8",o1="5",o2="8",o3="7"},
			[15] = {q="4*6-3*7 = ?",a="3",o1="2",o2="3",o3="5"},
			[16] = {q="¿Qué es más veloz?",a="Guepardo",o1="Guepardo",o2="Leopardo",o3="Puma"},
			[17] = {q="8+8*2 = ?",a="32",o1="14",o2="32",o3="24"},
			[18] = {q="6/6 = ?",a="1",o1="0",o2="0'33",o3="1"},
			[19] = {q="80*10 = ?",a="800",o1="600",o2="800",o3="750"},
			[20] = {q="¿Qué es el 2H en una composición?",a="2 Hidrógenos",o1="2 Helios",o2="2 H2O",o3="2 Hidrógenos"},

			}
		elseif tonumber(val) == 5 then
			time = 1
			need = 17
			options = {

			[1] = {q="1/4 = ?",a="0'25",o1="0.001",o2="0.25",o3="0.15"},
			[2] = {q="¿Qué es más pequeño?",a="Electrón",o1="Átomo",o2="Electrón",o3="Molécula"},
			[3] = {q="1/? = 0'25",a="4",o1="2",o2="1/4",o3="4"},
			[4] = {q="1/3-0'33 = ?",a="0",o1="0",o2="0.4",o3="1"},
			[5] = {q="¿Qué está más lejos?",a="Neptuno",o1="Urano",o2="Neptuno",o3="Saturno"},
			[6] = {q="8*2+16-2 = ?",a="30",o1="28",o2="26",o3="30"},
			[7] = {q="?*9 = 81",a="9",o1="9",o2="7",o3="8"},
			[8] = {q="¿el 15% de 100 es?",a="15",o1="30",o2="30%",o3="15"},
			[9] = {q="¿Qué es más grande?",a="Cocodrilo",o1="Zorro",o2="Mapache",o3="Cocodrilo"},
			[10] = {q="14*8 = ?",a="112",o1="82",o2="96",o3="112"},
			[11] = {q="5+20*2 = ?",a="50",o1="50",o2="35",o3="45"},
			[12] = {q="√81 = ?",a="9",o1="40'5",o2="33'3",o3="9"},
			[13] = {q="¿Qué es más poderoso?",a="Estados Unidos",o1="Estados Unidos",o2="Rusia",o3="China"},
			[14] = {q="¿Cuantas caras tiene un Decaedro?",a="10",o1="14",o2="6",o3="10"},
			[15] = {q="4*9-4*8 = ?",a="4",o1="4",o2="6",o3="5"},
			[16] = {q="¿Qué es más veloz?",a="Guepardo",o1="Guepardo",o2="Liebre",o3="Ñu"},
			[17] = {q="16+16*2 = ?",a="64",o1="84",o2="74",o3="64"},
			[18] = {q="12/12 = ?",a="1",o1="0",o2="0'1",o3="1"},
			[19] = {q="90*100 = ?",a="9000",o1="900",o2="9000",o3="90000"},
			[20] = {q="¿Qué es el 2Fe en una composición?",a="2 Hierros",o1="2 Ferrios",o2="2 Hierros",o3="2 Fibras"},

			}
		end

		local gettime = 60*time
		timer.Create("counttime",1,60*time,function()
			gettime = gettime - 1
		end)

		LocalPlayer():SetNWBool("guienable",true)
			local scr = vgui.Create("DFrame")
			scr:SetSize(ScrW(),ScrH())
			scr:SetPos(0,0)
			scr:SetTitle("")
			scr:SetAlpha(0)
			scr:AlphaTo(255,1)
			scr:MakePopup()
			scr:ShowCloseButton(false)
			scr:SetDraggable(false)
			scr.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(18,48,83))
			draw.SimpleText("Clase de Matemáticas: "..val,"F_Enorme",w*0.01,h*0.01,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			if gettime <= 10 then
				if gettime <= 0 then return end
				draw.SimpleText("Tiempo: "..gettime,"F_Grande",w*0.01,h*0.11,Color(100,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			else
				draw.SimpleText("Tiempo: "..gettime,"F_Grande",w*0.01,h*0.11,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			end
			draw.SimpleText("Aciertos: "..aciertos.."/"..need.." necesarios","F_Grande",w*0.7,h*0.01,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			end

			function sendanswers()
			timer.Remove("counttime")
			removeArea()

			scr:AlphaTo(0,1,3)

			timer.Simple(4,function()
				scr:Remove()
				LocalPlayer():SetNWBool("guienable",false)

			if aciertos >= need then
				LocalPlayer():sendNotify("¡Has Superado la clase "..val.." de Matemáticas!")
				if val == 5 then
				LocalPlayer():sendNotify("¡Has Superado todas las clases! ya no hace falta que vengas, ven si quieres repasar.")
				end

				net.Start("_class")
				net.WriteEntity(LocalPlayer())
				net.WriteString(str)
				net.WriteString(val)
				net.SendToServer()
			else
				LocalPlayer():sendNotify("Lo sentimos, pero has suspendido")
			end

			end)
		end

		local load = 0
		function loadClass()
			if aciertos == 20 then return end
			if question == 20 then return end

			if load != 0 then
				removeLoad()
			end

			load = 1

			question = question + 1

			local area = vgui.Create("DFrame",scr)
			area:SetSize(scr:GetWide(),scr:GetTall())
			area:SetPos(scr:GetWide()*0,scr:GetTall()*0)
			area:SetTitle("")
			area:ShowCloseButton(false)
			area:SetDraggable(false)
			area.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
			end

			function removeArea()
				if !IsValid(area) then return end
				area:Remove()
			end

			local quest = vgui.Create("DButton",area)
			quest:SetSize(area:GetWide()*0.3,area:GetTall()*0.2)
			quest:CenterHorizontal(0.2)
			quest:CenterVertical(0.5)
			quest:SetText(options[question].q)
			quest:SetFont("F_Grande")
			quest:SetContentAlignment(4)
			quest:SetColor(Color(255,255,255))
			quest.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
			end

			local opt1 = vgui.Create("DButton",area)
			opt1:SetSize(area:GetWide()*0.4,area:GetTall()*0.1)
			opt1:CenterHorizontal(0.6)
			opt1:CenterVertical(0.3)
			opt1:SetText(options[question].o1)
			opt1:SetMouseInputEnabled(true)
			opt1:SetColor(Color(18,48,83))
			opt1:SetFont("F_Grande")
			opt1.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end

			opt1.DoClick = function()
				if options[question].o1 == options[question].a then
					aciertos = aciertos + 1
					LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/true.wav",0.5,1,true)
				else
					gettime = gettime - 5
					LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/false.wav",0.5,1,true)
				end
				if question > 20 then
					sendanswers()
				else
					removeLoad()
					timer.Simple(0.1,function()
						loadClass()
					end)
				end
			end

			local opt2 = vgui.Create("DButton",area)
			opt2:SetSize(area:GetWide()*0.4,area:GetTall()*0.1)
			opt2:CenterHorizontal(0.6)
			opt2:CenterVertical(0.5)
			opt2:SetText(options[question].o2)
			opt2:SetMouseInputEnabled(true)
			opt2:SetColor(Color(18,48,83))
			opt2:SetFont("F_Grande")
			opt2.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end

			opt2.DoClick = function()
				if options[question].o2 == options[question].a then
					aciertos = aciertos + 1
					LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/true.wav",0.5,1,true)
				else
					gettime = gettime - 5
					LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/false.wav",0.5,1,true)
				end
				if question > 20 then
					sendanswers()
				else
					removeLoad()
					timer.Simple(0.1,function()
						loadClass()
					end)
				end
			end

			local opt3 = vgui.Create("DButton",area)
			opt3:SetSize(area:GetWide()*0.4,area:GetTall()*0.1)
			opt3:CenterHorizontal(0.6)
			opt3:CenterVertical(0.7)
			opt3:SetText(options[question].o3)
			opt3:SetMouseInputEnabled(true)
			opt3:SetColor(Color(18,48,83))
			opt3:SetFont("F_Grande")
			opt3.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end

			opt3.DoClick = function()
				if options[question].o3 == options[question].a then
					aciertos = aciertos + 1
				else
					gettime = gettime - 5
				end
				if question > 20 then
					sendanswers()
				else
					removeLoad()
					timer.Simple(0.1,function()
						loadClass()
					end)
				end
			end

			local salir = vgui.Create("DButton",area)
			salir:SetSize(area:GetWide()*0.4,area:GetTall()*0.1)
			salir:CenterHorizontal(0.6)
			salir:CenterVertical(0.9)
			salir:SetText("TERMINAR")
			salir:SetMouseInputEnabled(true)
			salir:SetColor(Color(18,48,83))
			salir:SetFont("F_Grande")
			salir.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end

			salir.DoClick = function()
				salir:Remove()
				area:Remove()
				sendanswers()
			end

			function removeLoad()
				area:Remove()
			end

		end

		loadClass()

		timer.Create("checkingtime",1,0,function()
			if !IsValid(scr) then return end
			if questions == 20 then
				sendanswers()
				timer.Remove("checkingtime")
			end
			if gettime > 0 then return end

			sendanswers()
			timer.Remove("checkingtime")
		end)

	end

	function englishClass(val)
		if not table.HasValue(values,tonumber(val)) then return end

		local words
		local time
		local phrases
		local need
		local chars = {}
		local aciertos = 0
		if tonumber(val) == 1 then
			words = "AELMOS"
			time = 3
			need = 13
			phrases = {"AMO","ESA","ESO","LOA","MAL","MES","OLA","OLE","OSA","SAL","SOL","LEMA","LOMA","LOSA","MESA","MALO","MOLE","SOLA","SALMO","MELOSA"}
		elseif tonumber(val) == 2 then
			words = "ALRTSE"
			time = 2.5
			need = 15
			phrases = {"ERA","ESA","REA","RES","SAL","SER","TAL","TEA","ARTE","ESTA","REAL","SETA","TELA","TRAS","TRES","ESTAR","LETRA","RESTA","RETAL","TELAR","TERSA","LASTRE"}
		elseif tonumber(val) == 3 then
			words = "SADALO"
			time = 2.5
			need = 15
			phrases = {"ASA","ALA","DOS","LOA","ODA","OLA","OSA","SAL","SOL","LADO","LOSA","SALA","SODA","SOLA","LASA","ALADO","ASADO","SALDO","OSADA","SALADO","SOLADA"}
		elseif tonumber(val) == 4 then
			words = "OALEST"
			time = 2.5
			need = 18
			phrases = {"ALE","ESA","ESO","OLA","OSA","OLE","SAL","SOL","TAL","TEA","TOS","ALTO","ESTA","ESTO","LATO","LESA","LOSA","LOTE","SETA","SETO","SOLA","TELA","SALTO","SETAL","TESLA","ESTOLA","LOSETA","SOLETA"}
		elseif tonumber(val) == 5 then
			words = "AENRST"
			time = 2.4
			need = 19
			phrases = {"ERA","ESA","ETA","RAS","REA","RES","SAN","SER","TAN","TAS","TEA","TER","ARTE","ESTA","SETA","TRAS","TREN","TRES","ANTES","ESTAR","RENTA","RESTA","SERNA","TENSA","TERNA","TERSA","TRENA","SARTEN","SENTAR","TENSAR"}
		end

		local gettime = 60*time
		timer.Create("counttime",1,60*time,function()
			gettime = gettime - 1
		end)

		LocalPlayer():SetNWBool("guienable",true)
		local scr = vgui.Create("DFrame")
		scr:SetSize(ScrW(),ScrH())
		scr:SetPos(0,0)
		scr:SetTitle("")
		scr:SetAlpha(0)
		scr:AlphaTo(255,1)
		scr:MakePopup()
		scr:ShowCloseButton(false)
		scr:SetDraggable(false)
		scr.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(18,48,83))
		draw.SimpleText(words,"F_Enorme",w*0.42,h*0.4,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("Clase de Inglés: "..val,"F_Enorme",w*0.39,h*0.15,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		if gettime <= 10 then
			if gettime <= 0 then return end
			draw.SimpleText("Tiempo: "..gettime,"F_Grande",w*0.445,h*0.3,Color(100,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		else
			draw.SimpleText("Tiempo: "..gettime,"F_Grande",w*0.445,h*0.3,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end
		draw.SimpleText("Aciertos: "..aciertos.."/"..need.." necesarios","F_Grande",w*0.65,h*0.725,Color(247,173,41),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end

		local lph = 0
		function loadPhrases()
			if lph != 0 then lphRemove() end

			local l = vgui.Create( "DIconLayout", scr )
			l:SetSize(scr:GetWide()*0.3,scr:GetTall())
			l:SetPos(scr:GetWide()*0.01,scr:GetTall()*0.01)
			l:SetSpaceY( 5 )
			l:SetSpaceX( 5 )

			for k,v in pairs(chars) do
				local myText = l:Add("DButton")
				myText:SetSize(l:GetWide()*0.2,l:GetTall()*0.1)
				myText:SetPos(l:GetWide()*0,l:GetTall()*0)
				myText:SetText(v)
				myText:SetMouseInputEnabled(false)
				myText:SetColor(Color(255,255,255))
				myText:SetFont("F_Normal")
				myText.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
				end

			end

			lph = 1

			function lphRemove()
				l:Remove()
			end
		end

		local TextEntry = vgui.Create( "DTextEntry", scr )
		TextEntry:CenterVertical(0.5)
		TextEntry:CenterHorizontal(0.35)
		TextEntry:SetSize( scr:GetWide()*0.3,scr:GetTall()*0.15 )
		TextEntry:SetText( "" )
		TextEntry:SetFont("F_Enorme")
		TextEntry:SetTextColor(Color(18,48,83))
		TextEntry.OnEnter = function( self )
			local val = self:GetValue()
			if table.HasValue(phrases,string.upper(val)) then
				if table.HasValue(chars,val) then return end
				aciertos = aciertos + 1
				table.insert(chars,val)
				TextEntry:SetText( "" )
				loadPhrases()
				LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/true.wav",0.5,1,true)
			else
				gettime = gettime - 5
				LocalPlayer():playURL("http://www.headarrow.com/media/bullyrp/effects/false.wav",0.5,1,true)
			end
		end

		function sendanswers()
			TextEntry:Remove()
			timer.Remove("counttime")

			scr:AlphaTo(0,1,3)

			timer.Simple(4,function()
				scr:Remove()
				LocalPlayer():SetNWBool("guienable",false)

			if aciertos >= need then
				LocalPlayer():sendNotify("¡Has Superado la clase "..val.." de Inglés!")
				if val == 5 then
				LocalPlayer():sendNotify("¡Has Superado todas las clases! ya no hace falta que vengas, ven si quieres repasar.")
				end

				net.Start("_class")
				net.WriteEntity(LocalPlayer())
				net.WriteString(str)
				net.WriteString(val)
				net.SendToServer()
			else
				LocalPlayer():sendNotify("Lo sentimos, pero has suspendido")
			end

			end)
		end

		local salir = vgui.Create( "DButton", scr )
		salir:CenterVertical(0.7)
		salir:CenterHorizontal(0.35)
		salir:SetSize( scr:GetWide()*0.3,scr:GetTall()*0.1 )
		salir:SetText( "TERMINAR" )
		salir:SetFont("F_Enorme")
		salir.Paint = function(self,w,h)
			if salirH then
				salir:SetColor(Color(247,173,41))
				draw.RoundedBox(0,0,0,w,h,Color(18,48,83))
			else
				salir:SetColor(Color(18,48,83))
				draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			end
		end

		salir.OnCursorEntered = function()
			salirH = true
		end

		salir.OnCursorExited = function()
			salirH = false
		end

		salir.DoClick = function()
			sendanswers()
			salir:Remove()
		end

		hook.Add("Think","finishcounttime",function()
			if !IsValid(scr) then return end
			if gettime > 0 then return end
			salir:Remove()
		end)

	end

	timer.Create("checkingtime",1,0,function()
		if !IsValid(scr) then return end
		if gettime > 0 then return end

		sendanswers()
		timer.Remove("checkingtime")
	end)

	if string.lower(str) == "ingles" then
		englishClass(num)
	elseif string.lower(str) == "matematicas" then
		mathsClass(num)
	end

end

net.Receive("_class",function()
	local str = net.ReadString()
	local num = net.ReadString()

	_class(str,num)
end)

net.Receive("green",function()
	timer.Simple(1,function()
	local fm = vgui.Create("DFrame")
	fm:SetSize(ScrW(),ScrH())
	fm:SetPos(0,0)
	fm:SetAlpha(0)
	fm:AlphaTo(255,4)
	fm:SetTitle("")
	fm:ShowCloseButton(false)
	fm:SetDraggable(false)
	fm.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur(self,self.Start)
		draw.RoundedBox(0,0,0,w,h,Color(0,255,0,150))

		if LocalPlayer():GetNWBool("green") == false then

			removeGreen()

		end
	end


	function removeGreen()
		fm:AlphaTo(0,4,0,function()
			if IsValid(fm) then
			fm:Remove()
			end
		end)
	end
	end)

end)

local CreateScoreboard = function()
Scoreboard = vgui.Create("DFrame")
		Scoreboard:SetSize(ScrW()*.75, ScrH()*.75)
		Scoreboard:SetPos((ScrW()*.25)*.5, (ScrH()*.25)*.5)
		Scoreboard:SetTitle("")
		Scoreboard:SetAlpha(0)
		Scoreboard:AlphaTo(255,0.2,0)
		Scoreboard:SetDraggable(false)
		Scoreboard:ShowCloseButton(false)
		Scoreboard.Open = function(self)
			Scoreboard:SetVisible(true)
		end
		Scoreboard.Close = function(self)
			Scoreboard:SetVisible(false)
		end
		Scoreboard.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur(self,self.Start)
		draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
		surface.SetDrawColor(18,48,83)
		surface.DrawRect(w*0.004,h*0.008,w*0.993,h*0.985)
		end


		local dimg = vgui.Create("DHTML",Scoreboard)
		dimg:SetSize(Scoreboard:GetWide(),Scoreboard:GetTall())
		dimg:SetPos(Scoreboard:GetWide()*0,Scoreboard:GetTall()*0)
		dimg:SetMouseInputEnabled(false)
		dimg:SetHTML([[
			<img src="https://i.imgur.com/w9mYPE6.png" height="200" width="400"/>
		]])
		dimg.Paint = function(self,w,h)
		draw.SimpleText(namedversion,"F_Mini",w*0.06,h*0.25,Color(247,173,41,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("V."..version,"F_Mini",w*0.2,h*0.25,Color(247,173,41,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("BULLYRP.HEADARROW.COM","F_Mini+",w*0.67,h*0.21,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end

		local b = vgui.Create("DButton",Scoreboard)
		b:SetSize(Scoreboard:GetWide()*0.25,Scoreboard:GetTall()*0.08)
		b:SetPos(Scoreboard:GetWide()*0.65,Scoreboard:GetTall()*0.12)
		b:SetText("JUGADORES EN LÍNEA: "..#player.GetAll().."/"..game.MaxPlayers())
		b:SetFont("F_Mini+")
		b:SetColor(Color(18,48,83))
		b:SetMouseInputEnabled(false)
		b.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(247,173,41,255))
		end

		local Scroll = vgui.Create( "DScrollPanel", Scoreboard )
		Scroll:SetSize(Scoreboard:GetWide()*0.9,Scoreboard:GetTall()*0.6)
		Scroll:SetPos(Scoreboard:GetWide()*0.05,Scoreboard:GetTall()*0.35)

		local sbar = Scroll:GetVBar()
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 57,57,57, 0 ) )
		end
		function sbar.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0,0 ) )
		end
		function sbar.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0,0 ) )
		end
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 5, w * 0.25, 0, w * 0.4, h, Color( 247,173,41 ) )
		end

		local l = vgui.Create( "DIconLayout", Scroll )
		l:SetSize(Scroll:GetWide()*0.95,Scroll:GetTall())
		l:SetPos(Scroll:GetWide()*0.025,Scroll:GetTall()*0)
		l:SetSpaceY( 5 )
		l:SetSpaceX( 5 )

		for k,v in pairs(player.GetAll()) do
			local bu = l:Add("DButton")
			bu:SetSize(l:GetWide(),Scoreboard:GetTall()*0.08)
			bu:SetPos(l:GetWide()*0,Scoreboard:GetTall()*0)
			bu:SetText(v:Nick())
			bu:SetFont("F_Normal")
			bu:SetColor(Color(247,173,41))
			bu.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(247,173,41))
			surface.SetDrawColor(18,48,83)
			surface.DrawRect(w*0.002,h*0.04,w*0.997,h*0.93)
			end
			bu.DoClick = function()
				v:ShowProfile()
			end
		end

end

function ScoreboardOpened()
		if LocalPlayer():GetNWBool("guienable") then return end
		if !ValidPanel(Scoreboard) then
			CreateScoreboard()
		end

		gui.EnableScreenClicker(true)
		
		return true
	end
	hook.Add("ScoreboardShow", "Open scoreboard.", ScoreboardOpened)

	function ScoreboardClosed()
		if !ValidPanel(Scoreboard) then
			CreateScoreboard()
		end

		Scoreboard:AlphaTo(0,0.2,0,function()
			Scoreboard:Remove()
		end)
		gui.EnableScreenClicker(false)
		return true
	end
	hook.Add("ScoreboardHide", "Close scoreboard.", ScoreboardClosed)
end

net.Receive("death_screen", function()
	local death_screen = vgui.Create( "DFrame" )
	death_screen:SetSize( ScrW(), ScrH() )
	death_screen:ShowCloseButton( false )
	death_screen:SetAlpha(0)
	death_screen:AlphaTo(255,2,0)
	death_screen:SetTitle( "" )
	function death_screen:Paint()
		draw.RoundedBoxEx( 0, 0, 0, ScrW(), ScrH(),Color( 0, 0, 0, 255 ) )
		draw.SimpleText( "INCONSCIENTE", "F_Enorme", ScrW()/2, ScrH()/2+math.sin(CurTime())*5, Color( 247,173,41 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
	end
	timer.Simple( 6.5, function()
		death_screen:AlphaTo(0,2,0,function()
		death_screen:Remove()
		death_screen = nil
		end)
	end )
end )