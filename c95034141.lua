--黄金郷の七摩天
function c95034141.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddFusionEffectProcUltimate(c,{
		mat_filter=aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),
		reg=false
	})
	e2:SetDescription(aux.Stringid(95034141,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,95034141)
	c:RegisterEffect(e2)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95034141,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,95034142)
	e2:SetCondition(c95034141.alcon)
	e2:SetTarget(c95034141.altg)
	e2:SetOperation(c95034141.alop)
	c:RegisterEffect(e2)
end
function c95034141.alfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function c95034141.alcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95034141.alfilter,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c95034141.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c95034141.altg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c95034141.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95034141.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95034141,2))
	local g=Duel.SelectTarget(tp,c95034141.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
end
function c95034141.alop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
