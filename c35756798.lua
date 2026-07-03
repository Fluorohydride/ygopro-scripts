--ファイナル・クロス
function c35756798.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,35756798+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c35756798.atkcon)
	e1:SetTarget(c35756798.atktg)
	e1:SetOperation(c35756798.atkop)
	c:RegisterEffect(e1)
	if not c35756798.global_check then
		c35756798.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(c35756798.checkcon)
		ge1:SetOperation(c35756798.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c35756798.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c35756798.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_SYNCHRO)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetControler(),35756798)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),35756798,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,35756798)>0 and Duel.GetFlagEffect(1,35756798)>0 then
			break
		end
		tc=g:GetNext()
	end
end
function c35756798.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,35756798)
	return Duel.GetTurnPlayer()==tp and aux.bpcon(e,tp,eg,ep,ev,re,r,rp) and ct>0
end
function c35756798.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c35756798.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c35756798.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c35756798.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c35756798.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsOriginalSetCard(0x66,0x1017,0xa3) then
		Duel.SetTargetParam(1)
	end
end
function c35756798.atkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:GetAttack()>0
end
function c35756798.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if num>0 and Duel.IsExistingMatchingCard(c35756798.atkfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(35756798,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local ag=Duel.SelectMatchingCard(tp,c35756798.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.HintSelection(ag)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(ag:GetFirst():GetAttack())
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
