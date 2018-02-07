local safe={--the min values must be first
-- players will be safe from damage if they are inside a box defined by these two vectors
	Vector(-2340.81,-2008.91,-203.71),
	Vector(-1468.72,-1132.25,-36.87)
}

local spawn={--the min values must be first
--	players will spawn somewhere inside a box defined by these two vectors
	Vector(-2203,-1861,96),
	Vector(-1608,-1282,96)
}

local line1="Revenant's safe zone"
local color1=Color(255,255,255,255)

local line2="you are free of all damage"
local color2=Color(255,255,255,255)

local line3=""
local color3=Color(255,255,255,255)

local line4=""
local color4=Color(255,255,255,255)

local line5=""
local color5=Color(255,255,255,255)


hook.Add("PlayerSpawn","revenants_safezone",function(ply)
	timer.Simple(0,function()
		if ply and ply:IsValid() and ply:IsPlayer() then
			if ply:isArrested() then return end --don't send arrested players to the fountain
			ply:SetPos(Vector(math.random(spawn[1].x,spawn[2].x),math.random(spawn[1].y,spawn[2].y),math.random(spawn[1].z,spawn[2].z)))
		end
	end)
end)

hook.Add("EntityTakeDamage","revenants_safezone",function(ply,CTakeDamageInfo)
	local attacker=CTakeDamageInfo:GetAttacker() or CTakeDamageInfo:GetInflictor():CPPIGetOwner()
	if attacker and attacker:IsPlayer() and attacker:GetPos():WithinAABox(safe[1],safe[2]) then--is the attacker in spawn?
		CTakeDamageInfo:SetDamage(0) -- prevent spawn abuse
		CTakeDamageInfo:SetDamageType(DMG_FALL) -- fall damage doesn't take away armor
	elseif ply and ply:IsPlayer() and ply:GetPos():WithinAABox(safe[1],safe[2]) then--is the player in spawn?
		CTakeDamageInfo:SetDamage(0) -- block damage
		CTakeDamageInfo:SetDamageType(DMG_FALL) -- fall damage doesn't take away armor
	end
end)
hook.Add("HUDPaint","revenants_safezone",function()
	if LocalPlayer():GetPos():WithinAABox(safe[1],safe[2]) then
		draw.DrawText(line1.."\n".."\n\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color1,TEXT_ALIGN_CENTER)
		draw.DrawText("\n"..line2.."\n\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color2,TEXT_ALIGN_CENTER)
		draw.DrawText("\n\n"..line3.."\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color3,TEXT_ALIGN_CENTER)
		draw.DrawText("\n\n\n"..line4.."\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color4,TEXT_ALIGN_CENTER)
		draw.DrawText("\n\n\n".."\n"..line5,"CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color5,TEXT_ALIGN_CENTER)
	end
end)
