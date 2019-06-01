--星遺物の囁き
function c62530723.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c62530723.target)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c62530723.discon)
	e2:SetOperation(c62530723.disop)
	c:RegisterEffect(e2)
end
function c62530723.atkfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function c62530723.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c62530723.atkfilter(chkc) end
	if chk==0 then
		if Duel.GetCurrentPhase()==PHASE_DAMAGE then
			return Duel.IsExistingTarget(c62530723.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		end
		return true
	end
	if Duel.GetCurrentPhase()==PHASE_DAMAGE
		or (Duel.IsExistingTarget(c62530723.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(62530723,0))) then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c62530723.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c62530723.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e:SetOperation(nil)
	end
end
function c62530723.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c62530723.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0x10c) and seq1==4-seq2
end
function c62530723.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and loc&LOCATION_SZONE==LOCATION_SZONE and seq<=4
		and Duel.IsExistingMatchingCard(c62530723.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c62530723.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,62530723)
	Duel.NegateEffect(ev)
end
