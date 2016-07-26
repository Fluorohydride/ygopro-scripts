--創星の因子
function c65236257.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(c65236257.target)
	e1:SetOperation(c65236257.activate)
	c:RegisterEffect(e1)
end
function c65236257.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65236257.cfilter(c)
	return c:IsSetCard(0x9c) and c:IsFaceup()
end
function c65236257.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c65236257.cfilter,tp,LOCATION_ONFIELD,0,c)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(c65236257.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,c) end
	local g=Duel.GetMatchingGroup(c65236257.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c65236257.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c65236257.cfilter,tp,LOCATION_ONFIELD,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c65236257.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,c)
	Duel.Destroy(g,REASON_EFFECT)
end
