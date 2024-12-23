--魔力隔壁
---@param c Card
function c84117021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84117021.target)
	e1:SetOperation(c84117021.activate)
	c:RegisterEffect(e1)
end
function c84117021.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c84117021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c84117021.filter(chkc) end
	if chk==0 then return true end
	local opt=0
	if Duel.IsExistingTarget(c84117021.filter,tp,LOCATION_MZONE,0,1,nil) then
		opt=Duel.SelectOption(tp,aux.Stringid(84117021,0),aux.Stringid(84117021,1))
	end
	Duel.SetTargetParam(opt)
	if opt==0 then
		e:SetProperty(0)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c84117021.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c84117021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if opt==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetCondition(c84117021.sumcon)
		e4:SetOperation(c84117021.sumsuc)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(e6,tp)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_CHAIN_END)
		e7:SetOperation(c84117021.limop2)
		Duel.RegisterEffect(e7,tp)
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ATTACK_ANNOUNCE)
			e1:SetOperation(c84117021.atkop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c84117021.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c84117021.filter,1,nil)
end
function c84117021.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c84117021.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		Duel.RegisterFlagEffect(tp,84117021,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c84117021.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c84117021.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,84117021)
	e:Reset()
end
function c84117021.limop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,84117021)>0 then
		Duel.SetChainLimitTillChainEnd(c84117021.chainlm)
	end
	Duel.ResetFlagEffect(tp,84117021)
end
function c84117021.chainlm(e,ep,tp)
	return ep==tp
end
function c84117021.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
