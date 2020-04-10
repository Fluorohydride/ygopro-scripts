--王の襲来
function c37931734.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37931734+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c37931734.target)
	e1:SetOperation(c37931734.activate)
	c:RegisterEffect(e1)
end
function c37931734.filter(c,tp)
	return c:IsSetCard(0x134) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c37931734.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37931734.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c37931734.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c37931734.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
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
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
