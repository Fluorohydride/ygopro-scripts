--無情なはたき落とし
function c47439573.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c47439573.condition)
	e1:SetTarget(c47439573.target)
	e1:SetOperation(c47439573.activate)
	c:RegisterEffect(e1)
end
function c47439573.cfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT) and (c:IsPreviousLocation(LOCATION_GRAVE) or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)))
end
function c47439573.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47439573.cfilter,1,nil,1-tp)
end
function c47439573.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end
function c47439573.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c47439573.cfilter(c,tp)
end
function c47439573.rmfilter(c,g)
	return c:IsAbleToRemove() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c47439573.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=eg:Filter(c47439573.filter,nil,e,1-tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(c47439573.rmfilter,nil,dg)
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
