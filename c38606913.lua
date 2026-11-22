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
c38606913.mentioned_counter={
	[0x1038]=true,
}
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
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
		--record the battle target with a counter as it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD_P)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabel(tc:GetFieldID(),0,0)
		e1:SetLabelObject(tc)
		e1:SetOperation(c38606913.regop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--damage, also when the target monster is destroyed in the same battle
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetCondition(c38606913.damcon2)
		e2:SetOperation(c38606913.damop2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c38606913.regop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc:GetFieldID()~=fid then return end
	local bc=tc:GetBattleTarget()
	if bc and eg:IsContains(bc) and bc:IsReason(REASON_BATTLE) and bc:GetCounter(0x1038)>0 then
		e:SetLabel(fid,1,bc:GetBaseAttack())
	end
end
function c38606913.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local _,ct=te:GetLabel()
	return ct==1 and eg:IsContains(te:GetLabelObject())
end
function c38606913.damop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local fid,_,atk=te:GetLabel()
	te:SetLabel(fid,0,0)
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end
