--竜魔王ベクターP
function c69512157.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_SZONE)
	e1:SetTarget(c69512157.distg)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c69512157.disop)
	c:RegisterEffect(e2)
end
function c69512157.distg(e,c)
	return c:GetSequence()==6 or c:GetSequence()==7
end
function c69512157.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:IsActiveType(TYPE_SPELL) and p~=tp and loc==LOCATION_SZONE and (seq==6 or seq==7) then
		Duel.NegateEffect(ev)
	end
end
