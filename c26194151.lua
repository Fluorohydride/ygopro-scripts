--ネクロイド・シンクロ
function c26194151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26194151.target)
	e1:SetOperation(c26194151.activate)
	c:RegisterEffect(e1)
end
function c26194151.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c26194151.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
end
function c26194151.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c26194151.filter3,tp,LOCATION_GRAVE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,2)
end
function c26194151.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c26194151.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c26194151.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26194151.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c26194151.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c26194151.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c26194151.filter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,2)
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		tc:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
