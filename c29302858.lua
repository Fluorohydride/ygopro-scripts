--VS ラゼン
---@param c Card
function c29302858.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29302858,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,29302858)
	e1:SetTarget(c29302858.thtg)
	e1:SetOperation(c29302858.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--show fire for indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29302858,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29302859)
	e3:SetCost(c29302858.indescost)
	e3:SetTarget(c29302858.indestg)
	e3:SetOperation(c29302858.indesop)
	c:RegisterEffect(e3)
	--show fire and dark for destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29302858,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,29302859)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(c29302858.descost)
	e4:SetTarget(c29302858.destg)
	e4:SetOperation(c29302858.desop)
	c:RegisterEffect(e4)
end
function c29302858.thfilter(c)
	return c:IsSetCard(0x195) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c29302858.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29302858.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,29302858)==0 end
	Duel.RegisterFlagEffect(tp,29302858,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29302858.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29302858.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29302858.indescfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c29302858.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29302858.indescfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c29302858.indescfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseEvent(g,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function c29302858.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29302858)==0 end
	Duel.RegisterFlagEffect(tp,29302858,RESET_CHAIN,0,1)
end
function c29302858.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
end
function c29302858.descfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_DARK) and not c:IsPublic()
end
function c29302858.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c29302858.descfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_FIRE,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_FIRE,ATTRIBUTE_DARK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RaiseEvent(sg,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function c29302858.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,29302858)==0 end
	Duel.RegisterFlagEffect(tp,29302858,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c29302858.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.Destroy(g,REASON_EFFECT)
end
