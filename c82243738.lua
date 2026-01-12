--エンジェルO1
function c82243738.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82243738,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82243738+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c82243738.spcon)
	e1:SetTarget(c82243738.sptg)
	e1:SetOperation(c82243738.spop)
	c:RegisterEffect(e1)
	--Tribute Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82243738,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,7))
	e2:SetCondition(c82243738.trcon)
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
end
function c82243738.spfilter(c)
	return c:IsLevelAbove(7) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c82243738.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82243738.spfilter,tp,LOCATION_HAND,0,1,nil)
end
function c82243738.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c82243738.spfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c82243738.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c82243738.trcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
