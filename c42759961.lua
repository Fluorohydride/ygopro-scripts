--道化の一座 フレア
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.thfilter(c)
	return c:IsSetCard(0x1dc) and not (c:IsAllTypes(TYPE_RITUAL+TYPE_MONSTER)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			if dg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end
function s.tdfilter(c)
	return c:IsFaceupEx() and c:IsAllTypes(TYPE_RITUAL+TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsCanTurnSet()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	local b2=Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o)==0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2),1},
			{b2,aux.Stringid(id,3),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TODECK)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_GRAVE+LOCATION_MZONE)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)
		if aux.NecroValleyNegateCheck(g) then return end
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
