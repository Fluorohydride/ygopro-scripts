--ミスト・コンドル
function c65549080.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c65549080.spcon)
	e1:SetOperation(c65549080.spop)
	c:RegisterEffect(e1)
end
function c65549080.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x37) and c:IsAbleToHandAsCost() and (ft>0 or c:GetSequence()<5)
end
function c65549080.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c65549080.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c65549080.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c65549080.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(1700)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
