--バーサーキング
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
function c56535497.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon(e,tp,eg,ep,ev,re,r,rp) end
end
function c56535497.filter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsCanBeEffectTarget(e)
end
function c56535497.atkfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c56535497.gcheck(g)
	return g:IsExists(c56535497.atkfilter,1,nil)
end
function c56535497.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c56535497.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return #g>=2 and g:IsExists(c56535497.atkfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c56535497.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c56535497.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(56535497,2))
	local tc1=g:FilterSelect(tp,c56535497.atkfilter,1,1,nil):GetFirst()
	if not tc1 then return end
	local tc2=(g-tc1):GetFirst()
	local atk=math.ceil(tc1:GetAttack()/2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	if tc1:RegisterEffect(e1) and tc2 and tc2:IsFaceup() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e2)
	end
end
