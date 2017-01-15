--地天の騎士ガイアドレイク
function c58601383.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,97204936,c58601383.ffilter,1,true,true)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c58601383.efilter1)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c58601383.efilter2)
	c:RegisterEffect(e3)
end
c58601383.miracle_synchro_fusion=true
function c58601383.ffilter(c)
	return c:IsFusionType(TYPE_SYNCHRO) and not c:IsFusionType(TYPE_EFFECT)
end
function c58601383.efilter1(e,re,rp)
	return re:IsActiveType(TYPE_EFFECT)
end
function c58601383.efilter2(e,re)
	return re:IsActiveType(TYPE_EFFECT)
end
