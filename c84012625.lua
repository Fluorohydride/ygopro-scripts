--シューティング・ソニック
function c84012625.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(aux.bpcon)
	e1:SetTarget(c84012625.target)
	e1:SetOperation(c84012625.activate)
	c:RegisterEffect(e1)
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_RELEASE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c84012625.reptg)
	e2:SetValue(c84012625.repval)
	e2:SetOperation(c84012625.repop)
	c:RegisterEffect(e2)
end
function c84012625.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO)
end
function c84012625.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84012625.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84012625.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c84012625.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84012625.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--return to hand
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetOwnerPlayer(tp)
		e1:SetCondition(c84012625.tdcon)
		e1:SetOperation(c84012625.tdop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c84012625.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tp==e:GetOwnerPlayer() and tc and tc:IsControler(1-tp)
end
function c84012625.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c84012625.repfilter(c,tp,re)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO) and c:IsReason(REASON_COST)
		and c==re:GetHandler() and not c:IsReason(REASON_REPLACE)
end
function c84012625.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c84012625.repfilter,1,nil,tp,re)
		and e:GetHandler():IsAbleToRemoveAsCost() end
	return Duel.SelectYesNo(tp,aux.Stringid(84012625,0))
end
function c84012625.repval(e,c)
	return c84012625.repfilter(c,e:GetHandlerPlayer(),c:GetReasonEffect())
end
function c84012625.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_REPLACE)
end
