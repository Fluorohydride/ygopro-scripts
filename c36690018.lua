--逆転する運命
---@param c Card
function c36690018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c36690018.target)
	e1:SetOperation(c36690018.activate)
	c:RegisterEffect(e1)
end
function c36690018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5) and c:GetFlagEffect(FLAG_ID_REVERSAL_OF_FATE)~=0
end
function c36690018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c36690018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c36690018.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c36690018.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c36690018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetFlagEffect(FLAG_ID_REVERSAL_OF_FATE)~=0 and tc:GetFlagEffect(FLAG_ID_ARCANA_COIN)~=0 then
		local val=tc:GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)
		tc:SetFlagEffectLabel(FLAG_ID_ARCANA_COIN,1-val)
	end
end
