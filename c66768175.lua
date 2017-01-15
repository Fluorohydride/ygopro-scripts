--EMバラード
function c66768175.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c66768175.atkcon1)
	e1:SetOperation(c66768175.atkop1)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c66768175.atkcon2)
	e2:SetTarget(c66768175.atktg2)
	e2:SetOperation(c66768175.atkop2)
	c:RegisterEffect(e2)
end
function c66768175.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	e:SetLabelObject(bc)
	return bc:IsFaceup() and tc:IsFaceup() and tc:IsSetCard(0x9f)
end
function c66768175.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsFaceup() and bc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-600)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
	end
end
function c66768175.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and a:IsSetCard(0x9f)
end
function c66768175.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c66768175.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if a:IsFaceup() and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=math.max(0,a:GetAttack())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
