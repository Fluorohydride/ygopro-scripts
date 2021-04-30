--旅人の結彼岸
function c44771289.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsSetCard,0xb1))
	e1:SetDescription(aux.Stringid(44771289,0))
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44771289,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c44771289.atktg)
	e2:SetOperation(c44771289.atkop)
	c:RegisterEffect(e2)
end
function c44771289.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb1)
end
function c44771289.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44771289.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44771289.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c44771289.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c44771289.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
