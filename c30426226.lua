--スウィッチヒーロー
---@param c Card
function c30426226.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c30426226.target)
	e1:SetOperation(c30426226.activate)
	c:RegisterEffect(e1)
end
function c30426226.filter(c)
	return not c:IsAbleToChangeControler()
end
function c30426226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return g1:GetCount()>0 and g1:GetCount()==g2:GetCount()
		and g:FilterCount(c30426226.filter,nil)==0
		and Duel.GetMZoneCount(tp,g1,tp,LOCATION_REASON_CONTROL)>=g2:GetCount()
		and Duel.GetMZoneCount(1-tp,g2,1-tp,LOCATION_REASON_CONTROL)>=g1:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c30426226.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SwapControl(g1,g2)
end
