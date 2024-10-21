--Ai打ち
function c86449372.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,86449372+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c86449372.condition)
	e1:SetOperation(c86449372.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c86449372.reptg)
	e2:SetValue(c86449372.repval)
	e2:SetOperation(c86449372.repop)
	c:RegisterEffect(e2)
end
function c86449372.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsFaceup() and d:IsFaceup()
end
function c86449372.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if a:IsFaceup() and a:IsRelateToBattle() and d:IsFaceup() and d:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(d:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		a:RegisterEffect(e1)
		local g=Group.FromCards(a,d)
		g:KeepAlive()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLED)
		e2:SetLabelObject(g)
		e2:SetOperation(c86449372.damop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c86449372.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(Card.IsStatus,nil,STATUS_BATTLE_DESTROYED)
	local tc1=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local tc2=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if tc1 then
		Duel.Damage(tp,tc1:GetBaseAttack(),REASON_EFFECT,true)
	end
	if tc2 then
		Duel.Damage(1-tp,tc2:GetBaseAttack(),REASON_EFFECT,true)
	end
	Duel.RDComplete()
	g:DeleteGroup()
end
function c86449372.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x135) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c86449372.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c86449372.repfilter,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c86449372.repval(e,c)
	return c86449372.repfilter(c,e:GetHandlerPlayer())
end
function c86449372.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
