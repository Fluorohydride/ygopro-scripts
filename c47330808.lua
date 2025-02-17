--ホルスの先導－ハーピ
function c47330808.initial_effect(c)
	aux.AddCodeList(c,16528181)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,47330808+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47330808.sprcon)
	c:RegisterEffect(e1)
	--Leave Field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47330808,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,47330809)
	e2:SetCondition(c47330808.descon)
	e2:SetTarget(c47330808.destg)
	e2:SetOperation(c47330808.desop)
	c:RegisterEffect(e2)
end
function c47330808.sprfilter(c)
	return c:IsFaceup() and c:IsCode(16528181)
end
function c47330808.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47330808.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47330808.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end
function c47330808.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47330808.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c47330808.tgfilter(c,tp)
	return c:IsAbleToDeck() or c:IsAbleToHand()
end
function c47330808.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c47330808.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c47330808.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,2,nil)
	if not g:FilterCount(Card.IsAbleToHand,nil,e)==g:GetCount() then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	elseif not g:FilterCount(Card.IsAbleToDeck,nil,e)==g:GetCount() then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,2,0,0)
end
function c47330808.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()==2 then
		if tg:FilterCount(Card.IsAbleToHand,nil)==2 and (tg:FilterCount(Card.IsAbleToDeck,nil)<2 or Duel.SelectOption(tp,aux.Stringid(47330808,2),aux.Stringid(47330808,3))==0) then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			elseif tg:FilterCount(Card.IsAbleToDeck,nil)==2 then
				Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
