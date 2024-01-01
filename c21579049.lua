--白の循環礁
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
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
	local id=c:GetCode()
	return c:IsRace(RACE_FISH) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check,id)
end
function s.thfilter(c,e,tp,check,id)
	return c:IsCode(id) and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.spfilter(c)
	return c:IsRace(RACE_FISH) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
	if check then e:SetLabel(1) else e:SetLabel(0) end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp,check) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,check) end
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,check)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local id=tc:GetCode()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_FISH) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and e:GetLabel()==1
			local sc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check,id):GetFirst()
			if check and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
function s.tdfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsRace(RACE_FISH) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,c:GetCode())
end
function s.fselect(g,e,tp)
	return g:GetClassCount(Card.GetCode)==1 and g:IsExists(s.fcheck,1,nil,g,e,tp)
end
function s.fcheck(c,g,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:IsExists(s.fcheck2,1,c)
end
function s.fcheck2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckSubGroup(s.fselect,2,2,e,tp) end
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.cfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLocation(LOCATION_GRAVE)
end
function s.cfilter2(c,e,tp)
	return not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or g:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local sc=nil
		local dc=nil
		if g and g:GetCount()==2 then
			if g:FilterCount(s.cfilter,nil,e,tp)==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local dc=g:Select(tp,1,1,nil)
				local sc=(g-dc):GetFirst()
				Duel.SendtoDeck(dc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				local sg=Duel.GetOperatedGroup()
				if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) or sg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local dc=g:FilterSelect(tp,s.cfilter2,1,1,nil,e,tp)
				local sc=(g-dc):GetFirst()
				Duel.SendtoDeck(dc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				local sg=Duel.GetOperatedGroup()
					if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) or sg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
