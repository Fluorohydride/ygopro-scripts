--霊獣の相絆
function c75457624.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c75457624.cost)
	e1:SetTarget(c75457624.target)
	e1:SetOperation(c75457624.activate)
	c:RegisterEffect(e1)
end
function c75457624.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsAbleToRemoveAsCost()
end
function c75457624.cfilter1(c,cg,e,tp)
	return cg:IsExists(c75457624.cfilter2,1,c,c,e,tp)
end
function c75457624.cfilter2(c,mc,e,tp)
	return Duel.IsExistingMatchingCard(c75457624.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,mc))
end
function c75457624.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c75457624.filter(c,e,tp,mg)
	return c:IsSetCard(0xb5) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c75457624.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c75457624.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return cg:IsExists(c75457624.cfilter1,1,nil,cg,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=cg:FilterSelect(tp,c75457624.cfilter1,1,1,nil,cg,e,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=cg:FilterSelect(tp,c75457624.cfilter2,1,1,tc,tc,e,tp)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75457624.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75457624.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
