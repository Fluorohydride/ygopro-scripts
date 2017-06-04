--無差別崩壊
function c22802010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c22802010.target)
	e1:SetOperation(c22802010.activate)
	c:RegisterEffect(e1)
end
function c22802010.filter1(c)
	return c:IsFaceup() and (c:IsLevelBelow(11) or c:IsRankBelow(11))
end
function c22802010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22802010.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22802010.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22802010.filter2(c,lv)
	return c:IsFaceup() and (c:IsLevelBelow(lv) or c:IsRankBelow(lv))
end
function c22802010.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2=Duel.TossDice(tp,2)
	local g=Duel.GetMatchingGroup(c22802010.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,d1+d2)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
