--スパークガン
function c97362768.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,20721928))
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97362768,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c97362768.postg)
	e3:SetOperation(c97362768.posop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
end
function c97362768.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c97362768.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
		if c:GetFlagEffect(97362768)==0 then
			c:RegisterFlagEffect(97362768,RESET_EVENT+0x1fe0000,0,1,1)
		else
			local ct=c:GetFlagEffectLabel(97362768)
			ct=ct+1
			if ct==3 then Duel.Destroy(c,REASON_EFFECT)
			else c:SetFlagEffectLabel(97362768,ct) end
		end
	end
end
