--ローゲの焔
---@param c Card
function c18478530.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c18478530.condition)
	e2:SetTarget(c18478530.atktarget)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c18478530.spcon)
	e3:SetTarget(c18478530.sptg)
	e3:SetOperation(c18478530.spop)
	c:RegisterEffect(e3)
end
function c18478530.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x122)
end
function c18478530.condition(e)
	return Duel.IsExistingMatchingCard(c18478530.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c18478530.atktarget(e,c)
	return c:IsAttackBelow(2000)
end
function c18478530.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY+REASON_EFFECT)==REASON_DESTROY+REASON_EFFECT and rp==1-tp
end
function c18478530.filter(c,e,tp)
	return c:IsSetCard(0x122) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18478530.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18478530.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c18478530.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18478530.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
