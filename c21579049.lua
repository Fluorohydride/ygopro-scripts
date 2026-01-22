--白の循環礁
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to deck and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp,check)
	local check2=check and Duel.GetMZoneCount(tp,c)>0
	return c:IsRace(RACE_FISH) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check2,c:GetCode())
end
function s.thfilter(c,e,tp,check,code)
	return c:IsCode(code) and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.spcfilter(c)
	return c:IsRace(RACE_FISH) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp,check) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,check) end
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,check)
	if check then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRace(RACE_FISH)
		and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetLabel()==1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check,code):GetFirst()
		if not sc then return end
		if check and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end
function s.tgfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsRace(RACE_FISH)
		and c:IsAbleToDeck() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tdfilter1(c,g,e,tp)
	return c:IsAbleToDeck() and g:IsExists(Card.IsCanBeSpecialSummoned,1,c,e,0,tp,false,false)
end
function s.fselect(g,e,tp)
	return g:GetClassCount(Card.GetCode)==1 and g:IsExists(s.tdfilter1,1,nil,g,e,tp)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckSubGroup(s.fselect,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g~=2 then return end
	local exg=nil
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		exg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
		if #exg==2 then exg=nil end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dc=g:FilterSelect(tp,Card.IsAbleToDeck,1,1,exg):GetFirst()
	if not dc then return end
	g:RemoveCard(dc)
	Duel.SendtoDeck(dc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	if dc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
