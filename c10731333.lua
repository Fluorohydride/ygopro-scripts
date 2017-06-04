--EMオッドアイズ・ミノタウロス
function c10731333.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c10731333.ptg)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10731333.atkcon)
	e2:SetOperation(c10731333.atkop)
	c:RegisterEffect(e2)
end
function c10731333.ptg(e,c)
	return c:IsSetCard(0x9f) or c:IsSetCard(0x99)
end
function c10731333.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x9f) or c:IsSetCard(0x99))
end
function c10731333.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	local gc=Duel.GetMatchingGroupCount(c10731333.atkfilter,tp,LOCATION_ONFIELD,0,nil)
	return a:IsControler(tp) and a:IsType(TYPE_PENDULUM) and d
		and d:IsFaceup() and not d:IsControler(tp) and gc>0
end
function c10731333.atkop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttacker():GetBattleTarget()
	local gc=Duel.GetMatchingGroupCount(c10731333.atkfilter,tp,LOCATION_ONFIELD,0,nil)
	if d:IsRelateToBattle() and d:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(-gc*100)
		d:RegisterEffect(e1)
	end
end
