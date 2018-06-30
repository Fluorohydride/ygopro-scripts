--コード・ラジエーター
function c75130221.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75130221.matcon)
	e1:SetValue(c75130221.matval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c75130221.ctcon)
	e2:SetOperation(c75130221.ctop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75130221,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,75130221)
	e3:SetCondition(c75130221.discon)
	e3:SetTarget(c75130221.distg)
	e3:SetOperation(c75130221.disop)
	c:RegisterEffect(e3)
end
function c75130221.matcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),75130221)==0
end
function c75130221.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE)
end
function c75130221.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(75130221)
end
function c75130221.matval(e,c,mg)
	return c:IsSetCard(0x101) and mg:IsExists(c75130221.mfilter,1,nil) and not mg:IsExists(c75130221.exmfilter,1,nil)
end
function c75130221.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c75130221.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,75130221,RESET_PHASE+PHASE_END,0,1)
end
function c75130221.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101)
end
function c75130221.disfilter(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDisabled())
end
function c75130221.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c75130221.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75130221.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75130221.disfilter,tp,0,LOCATION_MZONE,1,1+e:GetLabel(),nil)
end
function c75130221.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
