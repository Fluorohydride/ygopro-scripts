--浮幽さくら
function c62015408.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62015408,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62015408)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCondition(c62015408.rmcon)
	e1:SetCost(c62015408.rmcost)
	e1:SetTarget(c62015408.rmtg)
	e1:SetOperation(c62015408.rmop)
	c:RegisterEffect(e1)
end
function c62015408.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c62015408.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD)
end
function c62015408.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  not Duel.IsPlayerAffectedByEffect(tp,30459350)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c62015408.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg:GetFirst())
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,cg)
	local rg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_EXTRA,nil,sg:GetFirst():GetCode())
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
