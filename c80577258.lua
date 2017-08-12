--雪の天気模様
--Prototype, might require a core update for full functionality
function c80577258.initial_effect(c)
	c:SetUniqueOnField(1,0,80577258)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c80577258.effop)
	c:RegisterEffect(e2)
end
function c80577258.efffilter(c,g,ignore_flag)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109)
		and c:GetSequence()<5 and g:IsContains(c) and (ignore_flag or c:GetFlagEffect(80577258)==0)
end
function c80577258.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup(1,1)
	local g=Duel.GetMatchingGroup(c80577258.efffilter,tp,LOCATION_MZONE,0,nil,cg)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(80577258,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(80577258,0))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(c)
		e1:SetCost(aux.bfgcost)
		e1:SetTarget(c80577258.thtg)
		e1:SetOperation(c80577258.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c80577258.thfilter(c)
	return c:IsSetCard(0x109) and c:IsAbleToHand()
end
function c80577258.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=e:GetLabelObject()
	if chk==0 then return gc and gc:IsFaceup() and gc:IsLocation(LOCATION_SZONE)
		and not gc:IsDisabled() and c80577258.efffilter(e:GetHandler(),gc:GetColumnGroup(1,1),true)
		and Duel.IsExistingMatchingCard(c80577258.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c80577258.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80577258.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(LOCATION_DECK,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
