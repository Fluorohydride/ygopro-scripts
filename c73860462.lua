--ワンダー・エクシーズ
function c73860462.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c73860462.target)
	e1:SetOperation(c73860462.activate)
	c:RegisterEffect(e1)
end
function c73860462.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil)
end
function c73860462.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73860462.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c73860462.activate(e,tp,eg,ep,ev,re,r,rp)
	local xyzg=Duel.GetMatchingGroup(c73860462.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil)
	end
end
