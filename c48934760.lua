--終焉の地
---@param c Card
function c48934760.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c48934760.condition)
	e1:SetTarget(c48934760.target)
	e1:SetOperation(c48934760.activate)
	c:RegisterEffect(e1)
end
function c48934760.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function c48934760.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48934760.cfilter,1,nil,tp)
end
function c48934760.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c48934760.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48934760.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c48934760.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48934760,0))
	local tc=Duel.SelectMatchingCard(tp,c48934760.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
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
