--天魔大帝
function c90122655.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c90122655.chainop)
	c:RegisterEffect(e1)
end
function c90122655.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsSummonType(SUMMON_TYPE_NORMAL) then
		Duel.SetChainLimit(c90122655.chainlm)
	end
end
function c90122655.chainlm(e,rp,tp)
	return tp==rp
end
