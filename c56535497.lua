--バーサーキング
---@param c Card
function c56535497.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56535497,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c56535497.condition)
	e2:SetTarget(c56535497.target)
	e2:SetOperation(c56535497.operation)
	c:RegisterEffect(e2)
end
function c56535497.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function c56535497.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon(e,tp,eg,ep,ev,re,r,rp) end
end
function c56535497.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c56535497.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(56535497,2))
	local rg=Duel.SelectTarget(tp,c56535497.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(rg:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(56535497,3))
	Duel.SelectTarget(tp,c56535497.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,rg:GetFirst())
end
function c56535497.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=e:GetLabelObject()
	if not tc1 then return end
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		local atk=math.ceil(tc1:GetAttack()/2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e2)
	end
end
