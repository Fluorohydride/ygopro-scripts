--竜呼相打つ
function c14733538.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14733538.target)
	e1:SetOperation(c14733538.activate)
	c:RegisterEffect(e1)
end
function c14733538.filter1(c,e,tp,flag)
	return c:IsSetCard(0xc7) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra() and (not flag or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c14733538.filter2(c,e,tp,flag)
	return c:IsSetCard(0xda) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra() and (not flag or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c14733538.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return (not flag or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(c14733538.filter1,tp,LOCATION_DECK,0,1,nil,e,tp,flag)
		and Duel.IsExistingMatchingCard(c14733538.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,flag) end
end
function c14733538.activate(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if flag and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(c14733538.filter1,tp,LOCATION_DECK,0,nil,e,tp,flag)
	local g2=Duel.GetMatchingGroup(c14733538.filter2,tp,LOCATION_DECK,0,nil,e,tp,flag)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,560)
	local sg1=g1:Select(tp,1,1,nil)
	local sc=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,560)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	local rg=sg1:RandomSelect(1-tp,1)
	Duel.ConfirmCards(tp,rg)
	local tc=rg:GetFirst()
	sg1:RemoveCard(tc)
	local ec=sg1:GetFirst()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (flag or Duel.SelectYesNo(tp,aux.Stringid(14733538,0)))then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	Duel.PSendtoExtra(g,nil,REASON_EFFECT)
end
