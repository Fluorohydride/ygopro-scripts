--ペンデュラム・エクシーズ
function c46005939.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,46005939+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c46005939.target)
	e1:SetOperation(c46005939.activate)
	c:RegisterEffect(e1)
end
function c46005939.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c46005939.spfilter2,tp,LOCATION_PZONE,0,1,c,e,tp,c)
end
function c46005939.xyzlv(e,c,rc)
	return e:GetHandler():GetLevel()+e:GetLabel()*0x10000
end
function c46005939.spfilter2(c,e,tp,mc)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	local e1=nil
	local e2=nil
	if c:IsLevelAbove(1) and mc:IsLevelAbove(1) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(c46005939.xyzlv)
		e1:SetLabel(mc:GetLevel())
		c:RegisterEffect(e1,true)
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(c46005939.xyzlv)
		e2:SetLabel(c:GetLevel())
		mc:RegisterEffect(e2,true)
	end
	local res=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,mc),2,2)
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	return res
end
function c46005939.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c46005939.spfilter1,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c46005939.spfilter3(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46005939.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c46005939.spfilter3,nil,e,tp)
	if g:GetCount()<2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc1:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc1:RegisterEffect(e2)
	local e3=e1:Clone()
	tc2:RegisterEffect(e3)
	local e4=e2:Clone()
	tc2:RegisterEffect(e4)
	Duel.SpecialSummonComplete()
	local e5=nil
	local e6=nil
	if tc1:IsLevelAbove(1) and tc2:IsLevelAbove(1) then
		e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_XYZ_LEVEL)
		e5:SetValue(c46005939.xyzlv)
		e5:SetLabel(tc2:GetLevel())
		tc1:RegisterEffect(e5,true)
		e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_XYZ_LEVEL)
		e6:SetValue(c46005939.xyzlv)
		e6:SetLabel(tc1:GetLevel())
		tc2:RegisterEffect(e6,true)
	end
	local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,g,2,2)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
	if e5 then e5:Reset() end
	if e6 then e5:Reset() end
end
