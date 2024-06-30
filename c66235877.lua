--デス・デーモン・ドラゴン
function c66235877.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,93220472,16475472,false,false)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c66235877.distg)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c66235877.disop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c66235877.distg2)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(c66235877.distg2)
	c:RegisterEffect(e4)
end
function c66235877.distg(e,c)
	return c:IsType(TYPE_FLIP)
end
function c66235877.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_FLIP) then Duel.NegateEffect(ev) end
	if e:GetHandler():IsRelateToEffect(re)
		and re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			Duel.NegateEffect(ev)
		end
	end
end
function c66235877.distg2(e,c)
	return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
		and c:GetCardTarget():IsContains(e:GetHandler())
end
