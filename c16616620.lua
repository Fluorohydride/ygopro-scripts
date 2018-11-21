--コンタクト
function c16616620.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16616620.target)
	e1:SetOperation(c16616620.activate)
	c:RegisterEffect(e1)
end
function c16616620.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1e) and Duel.IsExistingMatchingCard(c16616620.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c,e,tp)
end
function c16616620.filter2(c,mc,e,tp)
	return c:IsSetCard(0x1f) and aux.IsCodeListed(mc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c16616620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c16616620.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c16616620.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x1e)
end
function c16616620.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16616620.filter3,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local tg=Duel.GetMatchingGroup(c16616620.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tc,e,tp)
		sg:Merge(tg)
		tc=g:GetNext()
	end
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
	end
end
