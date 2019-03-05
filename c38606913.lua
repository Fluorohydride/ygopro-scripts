--方界縁起
function c38606913.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38606913,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,38606913)
	e1:SetTarget(c38606913.target)
	e1:SetOperation(c38606913.activate)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,38606914)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c38606913.damtg)
	e2:SetOperation(c38606913.damop)
	c:RegisterEffect(e2)
end
function c38606913.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3)
end
function c38606913.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38606913.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c38606913.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c38606913.ctfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(38606913,1))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1038,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetCondition(c38606913.condition)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e2)
	end
end
function c38606913.condition(e)
	return e:GetHandler():GetCounter(0x1038)>0
end
function c38606913.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER)
end
function c38606913.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c38606913.damfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c38606913.damfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c38606913.damfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c38606913.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD_P)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c38606913.regop)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetOperation(c38606913.damop2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(38606913,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c38606913.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	local ct=c:GetCounter(0x1038)
	e:SetLabel(ct)
end
function c38606913.damop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local ct=e:GetLabelObject():GetLabel()
	if c:GetFlagEffect(38606913)>0 and ct>0 then
		local atk=tc:GetBaseAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
