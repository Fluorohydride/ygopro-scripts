--フォトン・チェンジ
---@param c Card
function c42925441.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c42925441.target)
	c:RegisterEffect(e1)
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(42925441,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,42925441)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c42925441.effcost)
	e4:SetTarget(c42925441.efftg)
	e4:SetOperation(c42925441.effop)
	c:RegisterEffect(e4)
end
function c42925441.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42925441,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c42925441.descon)
	e1:SetOperation(c42925441.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
	if c42925441.effcost(e,tp,eg,ep,ev,re,r,rp,0)
		and c42925441.efftg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		c42925441.effcost(e,tp,eg,ep,ev,re,r,rp,1)
		c42925441.efftg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c42925441.effop)
	end
end
function c42925441.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c42925441.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c42925441.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(42925441)==0 end
	e:GetHandler():RegisterFlagEffect(42925441,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c42925441.costfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x55,0x7b) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c42925441.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c42925441.spfilter1(c,e,tp,cc)
	return c:IsSetCard(0x55) and c:IsType(TYPE_MONSTER) and not c:IsOriginalCodeRule(cc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c42925441.costfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x55,0x7b) and c:IsAbleToGraveAsCost()
end
function c42925441.thfilter(c)
	return c:IsSetCard(0x55) and not c:IsCode(42925441) and c:IsAbleToHand()
end
function c42925441.costfilter3(c,e,tp)
	return c:IsFaceup() and c:IsCode(93717133) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c42925441.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c42925441.spfilter2(c,e,tp,cc)
	return c42925441.spfilter1(c,e,tp,cc) and Duel.IsExistingMatchingCard(c42925441.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c42925441.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c42925441.costfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c42925441.costfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c42925441.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local b3=Duel.IsExistingMatchingCard(c42925441.costfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(42925441,1),aux.Stringid(42925441,2),aux.Stringid(42925441,3))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(42925441,1),aux.Stringid(42925441,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(42925441,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(42925441,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c42925441.costfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		Duel.SendtoGrave(g,REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c42925441.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c42925441.costfilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		Duel.SendtoGrave(g,REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c42925441.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local cc=e:GetLabelObject()
	local res=0
	if op~=1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c42925441.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,cc)
		if g:GetCount()>0 then
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c42925441.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if op==2 and res~=0 then Duel.BreakEffect() end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
