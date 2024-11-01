--ふわんだりぃずと怖い海
---@param c Card
function c77610503.initial_effect(c)
	--Activate(Special Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,77610503+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c77610503.discon)
	e1:SetTarget(c77610503.distg)
	e1:SetOperation(c77610503.disop)
	c:RegisterEffect(e1)
end
function c77610503.cfilter1(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup() and not c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c77610503.cfilter2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c77610503.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and aux.NegateSummonCondition()
		and Duel.IsExistingMatchingCard(c77610503.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c77610503.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c77610503.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
end
function c77610503.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e2:SetValue(3)
	Duel.RegisterEffect(e2,tp)
end
