--ラッキーパンチ
function c36378044.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c36378044.atktg1)
	e1:SetOperation(c36378044.atkop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36378044,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(1)
	e2:SetCondition(c36378044.atkcon)
	e2:SetTarget(c36378044.atktg2)
	e2:SetOperation(c36378044.atkop)
	c:RegisterEffect(e2)
	--life lost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c36378044.descon)
	e3:SetOperation(c36378044.desop)
	c:RegisterEffect(e3)
end
function c36378044.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c36378044.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer()
		and Duel.SelectYesNo(tp,aux.Stringid(36378044,1)) then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
		e:GetHandler():RegisterFlagEffect(36378044,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else e:SetLabel(0) end
end
function c36378044.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36378044)==0 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
	e:GetHandler():RegisterFlagEffect(36378044,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36378044.atkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local r1,r2,r3=Duel.TossCoin(tp,3)
	if r1+r2+r3==3 then
		Duel.Draw(tp,3,REASON_EFFECT)
	elseif r1+r2+r3==0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c36378044.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c36378044.desop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-6000)
end
