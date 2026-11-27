--ネクロバレーの神殿
function c56773577.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c56773577.atkcon)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--activate Necrovalley
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(56773577,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCondition(c56773577.accon)
	e4:SetTarget(c56773577.actg)
	e4:SetOperation(c56773577.acop)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(56773577,1))
	e5:SetCategory(CATEGORY_SSET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c56773577.setcon)
	e5:SetTarget(c56773577.settg)
	e5:SetOperation(c56773577.setop)
	c:RegisterEffect(e5)
end
function c56773577.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2e)
end
function c56773577.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c56773577.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsEnvironment(47355498)
end
function c56773577.accon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function c56773577.filter(c,tp)
	return c:IsCode(47355498) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c56773577.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56773577.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
end
function c56773577.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c56773577.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c56773577.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)
end
function c56773577.setfilter(c)
	return c:IsSetCard(0x91) and not c:IsCode(56773577) and c:IsSSetable()
end
function c56773577.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56773577.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c56773577.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c56773577.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
