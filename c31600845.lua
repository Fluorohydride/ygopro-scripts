--恐楽園の死配人 ＜Arlechino＞
function c31600845.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,31600845)
	e1:SetCondition(c31600845.spcon)
	e1:SetTarget(c31600845.sptg)
	e1:SetOperation(c31600845.spop)
	c:RegisterEffect(e1)
	--special summon and atk change 0
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31600845,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,0x21e0)
	e2:SetCountLimit(1,31600846)
	e2:SetCondition(c31600845.dhcon)
	e2:SetTarget(c31600845.dhtg)
	e2:SetOperation(c31600845.dhop)
	c:RegisterEffect(e2)
end
function c31600845.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x15b)
end
function c31600845.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c31600845.thfilter(c)
	return c:IsCode(20989253) and c:IsAbleToHand()
end
function c31600845.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c31600845.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(31600845,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tag=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tag)
	end
end
function c31600845.dhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c31600845.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetAttack()>0
end
function c31600845.spfilter(c,e,tp)
	return c:IsCode(94821366) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31600845.dhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and c31600845.xfilter(chkc) end
	if chk==0 then return c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c31600845.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
		and Duel.IsExistingMatchingCard(c31600845.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c31600845.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c31600845.dhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or c:GetLocation()~=LOCATION_DECK then return end
	local g=Duel.GetMatchingGroup(c31600845.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0
		or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
