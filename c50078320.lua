--刻印の調停者
function c50078320.initial_effect(c)
	--declear
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50078320.deccon)
	e1:SetCost(c50078320.deccost)
	e1:SetOperation(c50078320.decop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0x1e0)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c50078320.destg)
	e2:SetOperation(c50078320.desop)
	c:RegisterEffect(e2)
end
function c50078320.deccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasProperty(EFFECT_FLAG_DECLARE)
end
function c50078320.deccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c50078320.decop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.Hint(HINT_CODE,1-tp,ac)
	re:SetLabel(ac)
end
function c50078320.desfilter(c)
	return c:IsDestructable() and c:IsFaceup()
end
function c50078320.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c50078320.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50078320.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c50078320.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c50078320.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCondition(c50078320.secon)
		e1:SetOperation(c50078320.seop)
		e1:SetLabel(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		tc:RegisterEffect(e1)
	end
end
function c50078320.secon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		e:SetLabel(1)
		return false
	else
		return true
	end
end
function c50078320.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,50078320)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
