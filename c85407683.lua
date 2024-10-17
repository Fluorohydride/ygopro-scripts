--星満ちる新世壊
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.indcon)
	e2:SetValue(s.indct)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(56099748)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.filter(c,check)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToDeck() or check and c:IsAbleToHand())
end
function s.chkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if not aux.NecroValleyFilter()(tc) then return end
		local opt=0
		local b1=tc:IsAbleToDeck()
		local b2=tc:IsAbleToHand() and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_MZONE,0,1,nil)
		if b1 and not b2 then
			opt=1
		elseif b2 and not b1 then
			opt=2
		elseif b1 and b2 then
			opt=Duel.SelectOption(tp,1193,1190)+1
		end
		if opt==1 then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		elseif opt==2 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
