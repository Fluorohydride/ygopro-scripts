--黒蠍団召集
function c68191243.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c68191243.con)
	e1:SetTarget(c68191243.tg)
	e1:SetOperation(c68191243.op)
	c:RegisterEffect(e1)
end
function c68191243.cfilter(c)
	return c:IsFaceup() and c:IsCode(76922029)
end
function c68191243.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c68191243.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c68191243.filter(c,e,tp)
	return c:IsSetCard(0x1a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c68191243.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c68191243.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c68191243.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c68191243.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
