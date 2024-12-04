--LL－比翼の麗鳥
function c8243121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8243121,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,8243121)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c8243121.target)
	e1:SetOperation(c8243121.activate)
	c:RegisterEffect(e1)
	--change attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8243121,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,8243122)
	e2:SetCondition(c8243121.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c8243121.atktg)
	e2:SetOperation(c8243121.atkop)
	c:RegisterEffect(e2)
end
function c8243121.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf7)
		and (Duel.IsExistingMatchingCard(c8243121.atkfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
			or Duel.IsExistingMatchingCard(c8243121.lvfilter,tp,0,LOCATION_MZONE,1,nil))
end
function c8243121.atkfilter(c,atk)
	return c:IsFaceup() and not c:IsAttack(atk)
end
function c8243121.lvfilter(c)
	return c:IsFaceup() and (c:IsLevelAbove(2) or c:IsRankAbove(2))
end
function c8243121.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c8243121.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c8243121.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c8243121.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c8243121.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local g=Duel.GetMatchingGroup(c8243121.atkfilter,tp,0,LOCATION_MZONE,nil,atk)
		local cc=g:GetFirst()
		while cc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			cc:RegisterEffect(e1)
			cc=g:GetNext()
		end
	end
	local lg=Duel.GetMatchingGroup(c8243121.lvfilter,tp,0,LOCATION_MZONE,nil)
	local lc=lg:GetFirst()
	while lc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		if lc:IsLevelAbove(2) then
			e2:SetCode(EFFECT_CHANGE_LEVEL)
		end
		if lc:IsRankAbove(2) then
			e2:SetCode(EFFECT_CHANGE_RANK)
		end
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		lc:RegisterEffect(e2)
		lc=lg:GetNext()
	end
end
function c8243121.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(1-tp)
	if not (a and d) then return false end
	return Duel.GetAttacker()==a and d:IsFaceup() and d:IsSetCard(0xf7)
end
function c8243121.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(1-tp)
	if chk==0 then return d:GetAttack()~=a:GetAttack() end
end
function c8243121.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(1-tp)
	if a and d and d:IsRelateToBattle() and a:IsRelateToBattle() and d:IsFaceup() and a:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(a:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		d:RegisterEffect(e1)
	end
end
