--ウォークライ・メテオラゴン
function c10497636.initial_effect(c)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10497636,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10497636.discon)
	e2:SetTarget(c10497636.distg)
	e2:SetOperation(c10497636.disop)
	c:RegisterEffect(e2)
	--twice attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10497636,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(c10497636.atkcon)
	e3:SetTarget(c10497636.atktg)
	e3:SetOperation(c10497636.atkop)
	c:RegisterEffect(e3)
	--
	if not c10497636.global_check then
		c10497636.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_CONFIRM)
		ge1:SetOperation(c10497636.checkop)
		Duel.RegisterEffect(ge1,0)
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
function c10497636.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=c:GetBattleTarget()
	e:SetLabelObject(ac)
	return ac and ac:IsFaceup() and ac:IsControler(1-tp)
end
function c10497636.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=e:GetLabelObject()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ac,1,0,0)
end
function c10497636.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=e:GetLabelObject()
	if ac:IsFaceup() and ac:IsRelateToBattle() and ac:IsCanBeDisabledByEffect(e) and ac:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		ac:RegisterEffect(e2)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c10497636.distg2)
		e3:SetLabelObject(ac)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVING)
		e4:SetCondition(c10497636.discon2)
		e4:SetOperation(c10497636.disop2)
		e4:SetLabelObject(ac)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c10497636.distg2(e,c)
	local ac=e:GetLabelObject()
	return c:IsOriginalCodeRule(ac:GetOriginalCodeRule())
end
function c10497636.discon2(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(ac:GetOriginalCodeRule())
end
function c10497636.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c10497636.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10497636)>0
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c10497636.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c10497636.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10497636.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10497636.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10497636.atkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
