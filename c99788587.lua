--爆導索
function c99788587.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c99788587.condition)
	e1:SetTarget(c99788587.target)
	e1:SetOperation(c99788587.activate)
	c:RegisterEffect(e1)
end
function c99788587.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllColumn() and e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c99788587.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	e:SetLabel(aux.GetColumn(c)+1)
	local g=e:GetHandler():GetColumnGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99788587.opfilter(c,col)
	return aux.GetColumn(c)==col
end
function c99788587.activate(e,tp,eg,ep,ev,re,r,rp)
	local col=e:GetLabel()
	if col>0 then
		col=col-1
		local g=Duel.GetMatchingGroup(c99788587.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),col)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
