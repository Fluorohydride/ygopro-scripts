--八汰鏡
function c1200843.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c1200843.filter)
	--spirit may not return
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetValue(c1200843.desval)
	c:RegisterEffect(e4)
end
function c1200843.filter(c)
	return c:IsType(TYPE_SPIRIT)
end
function c1200843.desval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
