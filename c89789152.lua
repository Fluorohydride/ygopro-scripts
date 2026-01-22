--タキオン・ギャラクシースパイラル
function c89789152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,89789152+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c89789152.target)
	e1:SetOperation(c89789152.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89789152,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c89789152.handcon)
	c:RegisterEffect(e2)
end
function c89789152.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7b) and c:IsRace(RACE_DRAGON)
end
function c89789152.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c89789152.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c89789152.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c89789152.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c89789152.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c89789152.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c89789152.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c89789152.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x307b)
end
function c89789152.handcon(e)
	return Duel.IsExistingMatchingCard(c89789152.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
