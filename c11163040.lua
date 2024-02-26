--壊獣の出現記録
function c11163040.initial_effect(c)
	c:EnableCounterPermit(0x37)
	c:SetCounterLimit(0x37,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11163040.ctcon)
	e2:SetOperation(c11163040.counter)
	c:RegisterEffect(e2)
	aux.RegisterEachTimeEvent(c,EVENT_SPSUMMON_SUCCESS,c11163040.cfilter)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c11163040.ctcon2)
	e0:SetOperation(c11163040.counter2)
	c:RegisterEffect(e0)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11163040,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c11163040.target)
	e3:SetOperation(c11163040.operation)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11163040,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c11163040.thcon)
	e4:SetCost(c11163040.thcost)
	e4:SetTarget(c11163040.thtg)
	e4:SetOperation(c11163040.thop)
	c:RegisterEffect(e4)
end
function c11163040.cfilter(c)
	return c:IsSetCard(0xd3) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function c11163040.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11163040.cfilter,1,nil) and not Duel.IsChainSolving()
end
function c11163040.counter(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x37,1)
end
function c11163040.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11163040)>0
end
function c11163040.counter2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(11163040)
	e:GetHandler():ResetFlagEffect(11163040)
	e:GetHandler():AddCounter(0x37,ct,true)
end
function c11163040.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xd3)
		and Duel.IsExistingMatchingCard(c11163040.chkfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetControler(),c:GetOriginalCodeRule())
end
function c11163040.chkfilter(c,e,tp,cc,code)
	return c:IsSetCard(0xd3) and not c:IsOriginalCodeRule(code) and
		not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,cc,c)
end
function c11163040.spfilter(c,e,tp,cc,code)
	return c:IsSetCard(0xd3) and not c:IsOriginalCodeRule(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,cc)
end
function c11163040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11163040.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c11163040.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c11163040.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11163040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11163040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local cc=tc:GetControler()
	local code=tc:GetOriginalCodeRule()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(cc,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11163040.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,cc,code)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,cc,false,false,POS_FACEUP)
		end
	end
end
function c11163040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x37)>=3
end
function c11163040.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11163040.thfilter(c)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(11163040) and c:IsAbleToHand()
end
function c11163040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11163040.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11163040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11163040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
