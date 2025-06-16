--繋がり－Ai－
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_SEARCH|CATEGORY_SPECIAL_SUMMON|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.thdfilter(c)
	return c:IsAbleToHand() and not c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsLevelBelow(4) and c:IsRace(RACE_CYBERS)
end
function s.thndfilter(c,att)
	return c:IsAbleToHand() and not c:IsAttribute(att) and c:IsSetCard(0x135)
end
function s.cfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and not c:IsPublic()
		and (c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.thdfilter,tp,LOCATION_DECK,0,1,nil)
		or not c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(s.thndfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute()))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local gc=g:GetFirst()
	if gc:IsAttribute(ATTRIBUTE_DARK) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,gc,1,0,0)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_SEARCH|CATEGORY_TOHAND)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,gc,1,0,0)
		e:SetCategory(CATEGORY_TODECK|CATEGORY_SEARCH|CATEGORY_TOHAND)
	end
	Duel.SetTargetCard(g)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsAttribute(ATTRIBUTE_DARK) then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
				and Duel.IsExistingMatchingCard(s.thdfilter,tp,LOCATION_DECK,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,s.thdfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		else
			local att=tc:GetAttribute()
			if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK)
				and Duel.IsExistingMatchingCard(s.thndfilter,tp,LOCATION_DECK,0,1,nil,att) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,s.thndfilter,tp,LOCATION_DECK,0,1,1,nil,att)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end
