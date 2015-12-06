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
	return c:IsXyzSummonable(mg) and c.xyz_count<=ct
end
function c29087919.mfilter1(c,xc)
	return xc.xyz_filter(c)
end
function c29087919.mfilter2(c,xc,mg)
	local mg1=mg:Clone()
	mg1:AddCard(c)
	return xc:IsXyzSummonable(mg1)
end
function c29087919.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c29087919.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local mg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not mg:IsExists(Card.IsCode,1,nil,tc:GetCode()) then
			mg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	local ct=math.min(mg:GetCount(),Duel.GetLocationCount(tp,LOCATION_MZONE))
	local exg=Duel.GetMatchingGroup(c29087919.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and ct>1 and exg:GetCount()>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xg=exg:Select(tp,1,1,nil)
	local xc=xg:GetFirst()
	local count=xc.xyz_count
	local sg=Group.CreateGroup()
	while count>1 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:FilterSelect(tp,c29087919.mfilter1,1,1,nil,xc)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		sg:Merge(sg1)
		count=count-1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=g:FilterSelect(tp,c29087919.mfilter2,1,1,nil,xc,sg)
	sg:Merge(sg2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c29087919.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29087919.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg) and c.xyz_count==ct
end
function c29087919.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c29087919.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(c29087919.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
	if ct>=2 and xyzg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
