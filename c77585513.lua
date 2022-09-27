--人造人間－サイコ・ショッカー
function c77585513.initial_effect(c)
	--cannot trigger, normal version
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_SZONE,LOCATION_HAND+LOCATION_SZONE)
	e1:SetCondition(c77585513.condition1)
	e1:SetTarget(c77585513.distg)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetCondition(c77585513.condition1)
	e2:SetTarget(c77585513.distg)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77585513.discon1)
	e3:SetOperation(c77585513.disop1)
	c:RegisterEffect(e3)
	--disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c77585513.condition1)
	e4:SetTarget(c77585513.distg)
	c:RegisterEffect(e4)
	--Amplifier version
	local e5=e1:Clone()
	e5:SetTargetRange(0,LOCATION_HAND+LOCATION_SZONE)
	e5:SetCondition(c77585513.condition2)
	c:RegisterEffect(e5)
	--
	local e6=e2:Clone()
	e6:SetTargetRange(0,LOCATION_SZONE)
	e6:SetCondition(c77585513.condition2)
	c:RegisterEffect(e6)
	--
	local e7=e3:Clone()
	e7:SetCondition(c77585513.discon2)
	e7:SetOperation(c77585513.disop2)
	c:RegisterEffect(e7)
	--
	local e8=e4:Clone()
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetCondition(c77585513.condition2)
	c:RegisterEffect(e8)
end
function c77585513.condition1(e)
	return not e:GetHandler():IsHasEffect(303660)
end
function c77585513.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function c77585513.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(303660)
end
function c77585513.disop1(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
function c77585513.condition2(e)
	return e:GetHandler():IsHasEffect(303660)
end
function c77585513.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(303660)
end
function c77585513.disop2(e,tp,eg,ep,ev,re,r,rp)
	local p,tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	if p==1-e:GetHandlerPlayer() and tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
