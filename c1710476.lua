--Sin サイバー・エンド・ドラゴン
function c1710476.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c1710476.uqfilter,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1710476.spcon)
	e1:SetOperation(c1710476.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c1710476.descon)
	c:RegisterEffect(e7)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c1710476.antarget)
	c:RegisterEffect(e8)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
end
function c1710476.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),75223115) then
		return c:IsCode(1710476)
	else
		return c:IsSetCard(0x23)
	end
end
function c1710476.spfilter(c)
	return c:IsCode(1546123) and c:IsAbleToRemoveAsCost()
end
function c1710476.spfilter2(c,tp)
	return c:IsHasEffect(48829461,tp) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c1710476.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1710476.spfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1710476.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	return b1 or b2
end
function c1710476.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1710476.spfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1710476.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(48829461,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c1710476.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
		local te=tg:GetFirst():IsHasEffect(48829461,tp)
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		local tc=Duel.GetFirstMatchingCard(c1710476.spfilter,tp,LOCATION_EXTRA,0,nil)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
end
function c1710476.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c1710476.antarget(e,c)
	return c~=e:GetHandler()
end
