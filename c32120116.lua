--閻魔の裁き
function c32120116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c32120116.target)
	e1:SetOperation(c32120116.activate)
	c:RegisterEffect(e1)
end
function c32120116.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c32120116.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c32120116.filter,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c32120116.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c32120116.filter2(c,e,tp)
	return c:GetSummonPlayer()==tp and c:IsRelateToEffect(e)
end
function c32120116.rmfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function c32120116.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32120116.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c32120116.filter2,nil,e,1-tp)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c32120116.rmfilter),tp,LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(c32120116.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if #g1>4 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(32120116,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=g1:Select(tp,5,5,nil)
			if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==5 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g2:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
