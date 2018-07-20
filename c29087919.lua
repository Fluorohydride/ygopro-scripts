--ギアギアチェンジ
function c29087919.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29087919+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29087919.target)
	e1:SetOperation(c29087919.activate)
	c:RegisterEffect(e1)
end
function c29087919.filter(c,e,tp)
	return c:IsSetCard(0x1072) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29087919.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,2,ct)
end
function c29087919.mfilter1(c,mg,exg,ct)
	return mg:IsExists(c29087919.mfilter2,1,nil,Group.FromCards(c),mg,exg,ct)
end
function c29087919.mfilter2(c,g,mg,exg,ct)
	local tc=g:GetFirst()
	while tc do
		if c:IsCode(tc:GetCode()) then return false end
		tc=g:GetNext()
	end
	g:AddCard(c)
	local result=exg:IsExists(Card.IsXyzSummonable,1,nil,g,g:GetCount(),g:GetCount())
		or (g:GetCount()<ct and mg:IsExists(c29087919.mfilter2,1,nil,g,mg,exg,ct))
	g:RemoveCard(c)
	return result
end
function c29087919.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c29087919.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local exg=Duel.GetMatchingGroup(c29087919.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:IsExists(c29087919.mfilter1,1,nil,mg,exg,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c29087919.mfilter1,1,1,nil,mg,exg,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c29087919.mfilter2,1,1,nil,sg1,mg,exg,ct)
	sg1:Merge(sg2)
	while sg1:GetCount()<ct and mg:IsExists(c29087919.mfilter2,1,nil,sg1,mg,exg,ct)
		and (not exg:IsExists(Card.IsXyzSummonable,1,nil,sg1,sg1:GetCount(),sg1:GetCount()) or Duel.SelectYesNo(tp,aux.Stringid(29087919,0))) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=mg:FilterSelect(tp,c29087919.mfilter2,1,1,nil,sg1,mg,exg,ct)
		sg1:Merge(sg3)
	end
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c29087919.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29087919.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct)
end
function c29087919.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c29087919.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(c29087919.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
	if ct>=2 and xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
