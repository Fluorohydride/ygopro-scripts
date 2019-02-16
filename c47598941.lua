--アモルファージ・ライシス
function c47598941.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(47598941,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetHintTiming(TIMING_DAMAGE_STEP)
	e0:SetCondition(c47598941.condition)
	c:RegisterEffect(e0)
	--set p
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47598941,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,47598941)
	e2:SetCondition(c47598941.setcon)
	e2:SetTarget(c47598941.settg)
	e2:SetOperation(c47598941.setop)
	c:RegisterEffect(e2)
	--atk/def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c47598941.atktg)
	e3:SetValue(c47598941.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c47598941.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c47598941.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE) and c:GetPreviousControler()==tp
end
function c47598941.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47598941.cfilter,1,nil,tp)
end
function c47598941.filter(c)
	return c:IsSetCard(0xe0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47598941.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c47598941.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c47598941.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c47598941.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c47598941.atktg(e,c)
	return not c:IsSetCard(0xe0)
end
function c47598941.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c47598941.atkval(e,c)
	return Duel.GetMatchingGroupCount(c47598941.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end
