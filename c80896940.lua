--涅槃の超魔導剣士
function c80896940.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c80896940.matfilter1,nil,nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1,99)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c80896940.indcon)
	e3:SetOperation(c80896940.indop)
	c:RegisterEffect(e3)
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80896940,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c80896940.atkcon)
	e4:SetOperation(c80896940.atkop)
	c:RegisterEffect(e4)
	--salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80896940,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCondition(c80896940.thcon)
	e5:SetTarget(c80896940.thtg)
	e5:SetOperation(c80896940.thop)
	c:RegisterEffect(e5)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c80896940.valcheck)
	e0:SetLabelObject(e5)
	c:RegisterEffect(e0)
	--lp
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80896940,4))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(aux.bdocon)
	e6:SetOperation(c80896940.lpop)
	c:RegisterEffect(e6)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80896940,5))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c80896940.pencon)
	e7:SetTarget(c80896940.pentg)
	e7:SetOperation(c80896940.penop)
	c:RegisterEffect(e7)
end
c80896940.material_type=TYPE_SYNCHRO
function c80896940.matfilter1(c)
	return c:IsType(TYPE_TUNER) or (c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c80896940.indcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsType(TYPE_PENDULUM) and a:IsControler(tp)
end
function c80896940.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e2)
end
function c80896940.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsRelateToBattle() and a:IsType(TYPE_PENDULUM) and a:IsControler(tp)
end
function c80896940.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local atk=Duel.GetAttacker():GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function c80896940.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c80896940.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80896940.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c80896940.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c80896940.valcheck(e,c)
	local g=c:GetMaterial()
	local tg=g:Filter(c80896940.mfilter,nil)
	for tc in aux.Next(tg) do
		g:RemoveCard(tc)
		local flag=g:FilterCount(aux.NonTuner(Card.IsType,TYPE_SYNCHRO),nil,c)==g:GetCount()
		g:AddCard(tc)
		if flag then
			e:GetLabelObject():SetLabel(1)
			return
		end
	end
	e:GetLabelObject():SetLabel(0)
end
function c80896940.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end
function c80896940.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c80896940.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c80896940.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
