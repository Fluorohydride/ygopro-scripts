--魔救の奇石－ティアマイト
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--to decktop
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.dttg)
	e2:SetOperation(s.dtop)
	c:RegisterEffect(e2)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSpecialSummonSetCard(0x140)
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x140) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				Duel.ShuffleHand(tp)
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.texfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_ROCK) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end
function s.dttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and s.texfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.texfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=aux.SelectTargetFromFieldFirst(tp,s.texfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function s.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and aux.NecroValleyFilter()(tc) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
