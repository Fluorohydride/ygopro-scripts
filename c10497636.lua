--War Rock Meteoragon
--Script By JSY1728
function c10497636.initial_effect(c)
	--Immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(aux.indoval)
	c:RegisterEffect(e0)
	--Negate Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10497636,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10497636.negcon)
	e1:SetTarget(c10497636.negtg)
	e1:SetOperation(c10497636.negop)
	c:RegisterEffect(e1)
	--ATK UP and Double Attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10497636,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c10497636.doatcon)
	e2:SetOperation(c10497636.doatop)
	c:RegisterEffect(e2)
	if not c10497636.global_check then
		c10497636.global_check=true
		local gel=Effect.GlobalEffect(c)
		gel:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		gel:SetCode(EVENT_BATTLE_CONFIRM)
		gel:SetOperation(c10497636.checkop)
		Duel.RegisterEffect(gel,0)
	end
end
function c10497636.check(c)
	return c and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10497636.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c0,c1=Duel.GetBattleMonster(0)
	if c10497636.check(c0) then
		Duel.RegisterFlagEffect(0,10497636,RESET_PHASE+PHASE_END,0,1)
	end
	if c10497636.check(c1) then
		Duel.RegisterFlagEffect(1,10497636,RESET_PHASE+PHASE_END,0,1)
	end
end
function c10497636.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget()
end
function c10497636.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c10497636.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c10497636.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c10497636.discon)
		e2:SetOperation(c10497636.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c10497636.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10497636.discon(e,tp,eg,ep,ev,re,r,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10497636.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c10497636.doatcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10497636)>0
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and aux.dscon()
end
function c10497636.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c10497636.doatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c10497636.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
	end
end