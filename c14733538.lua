--竜呼相打つ
function c14733538.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14733538+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c14733538.target)
	e1:SetOperation(c14733538.activate)
	c:RegisterEffect(e1)
end
function c14733538.filter1(c,e,tp,b1)
	return c:IsSetCard(0xc7) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (b1 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c14733538.filter2(c,e,tp,b1)
	return c:IsSetCard(0xda) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (b1 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c14733538.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=not (Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7))
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(c14733538.filter1,tp,LOCATION_DECK,0,1,nil,e,tp,b1)
		and Duel.IsExistingMatchingCard(c14733538.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,b1) end
end
function c14733538.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=not (Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7))
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not b1 and not b2 then return end
	local g1=Duel.GetMatchingGroup(c14733538.filter1,tp,LOCATION_DECK,0,nil,e,tp,b1)
	local g2=Duel.GetMatchingGroup(c14733538.filter2,tp,LOCATION_DECK,0,nil,e,tp,b1)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	local cg=sg1:RandomSelect(1-tp,1)
	Duel.ConfirmCards(tp,cg)
	local tc=cg:GetFirst()
	if b1 and (not b2 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectYesNo(tp,aux.Stringid(14733538,0))) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	sg1:RemoveCard(tc)
	Duel.PSendtoExtra(sg1,nil,REASON_EFFECT)
end
