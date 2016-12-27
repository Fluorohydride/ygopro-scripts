--融合識別
function c59432181.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c59432181.target)
	e1:SetOperation(c59432181.activate)
	c:RegisterEffect(e1)
end
function c59432181.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c59432181.cfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c59432181.cfilter(c,tc)
	return c:IsType(TYPE_FUSION) and not c:IsCode(tc:GetFusionCode())
end
function c59432181.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c59432181.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c59432181.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c59432181.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c59432181.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c59432181.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local code1,code2=cg:GetFirst():GetOriginalCodeRule()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(59432181,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_FUSION_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(code1)
	tc:RegisterEffect(e1)
	if code2 then
		local e2=e1:Clone()
		e2:SetValue(code2)
		tc:RegisterEffect(e2)
	end
end
