--False Accusations
function c89883517.initial_effect(c)
	--BLock
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c89883517.condition)
	e1:SetCountLimit(1,89883517)
	e1:SetTarget(c89883517.target)
	e1:SetOperation(c89883517.operation)
	c:RegisterEffect(e1)
end
function c89883517.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	return ct1<ct2
end
function c89883517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	e:SetLabel(g:GetFirst():GetCode())
end

function c89883517.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c89883517.aclimit)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
end
function c89883517.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and (not re:GetHandler():IsImmuneToEffect(e) or not re:GetHandler()==e:GetHandler())
end

