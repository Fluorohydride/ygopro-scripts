--スプリガンズ・ブーティー
---@param c Card
function c7496001.initial_effect(c)
	aux.AddCodeList(c,60884672)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7496001,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,7496001)
	e2:SetCondition(c7496001.actcon)
	e2:SetTarget(c7496001.actg)
	e2:SetOperation(c7496001.actop)
	c:RegisterEffect(e2)
	--play fieldspell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7496001,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,7496002)
	e3:SetCost(c7496001.afcost)
	e3:SetTarget(c7496001.aftg)
	e3:SetOperation(c7496001.afop)
	c:RegisterEffect(e3)
end
function c7496001.actfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsReason(REASON_EFFECT) and c:GetPreviousTypeOnField()&TYPE_XYZ~=0
end
function c7496001.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7496001.actfilter,1,nil,tp)
end
function c7496001.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c7496001.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c7496001.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7496001.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(7496001,2))
	Duel.SelectTarget(tp,c7496001.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c7496001.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c7496001.afcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c7496001.affilter(c,tp)
	return c:IsCode(60884672) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c7496001.aftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7496001.affilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c7496001.afop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c7496001.affilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local field=tc:IsType(TYPE_FIELD)
		if field then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if field then
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
