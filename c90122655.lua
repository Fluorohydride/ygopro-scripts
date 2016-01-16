--天魔大帝
function c90122655.initial_effect(c)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c90122655.regcon)
	e1:SetOperation(c90122655.regop)
	c:RegisterEffect(e1)
end
function c90122655.regcon(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c90122655.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c90122655.chlimit)
end
function c90122655.chlimit(e,ep,tp)
	return tp==ep
end
