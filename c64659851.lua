--宇宙の法則
function c64659851.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64659851,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64659851+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c64659851.target)
	e1:SetOperation(c64659851.activate)
	c:RegisterEffect(e1)
end
function c64659851.spfilter(c,e,tp)
	return c:IsCode(77585513) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64659851.thfilter(c)
	return (c:IsCode(77585513) or aux.IsCodeListed(c,77585513) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c64659851.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c64659851.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
			or Duel.IsExistingMatchingCard(c64659851.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
end
function c64659851.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function c64659851.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=1
	local g=Duel.GetMatchingGroup(c64659851.setfilter,tp,0,LOCATION_HAND+LOCATION_DECK,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(64659851,0))
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
		sel=Duel.SelectOption(1-tp,1213,1214)
	else
		sel=Duel.SelectOption(1-tp,1214)+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg=g:Select(1-tp,1,1,nil)
		if Duel.SSet(1-tp,sg)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local pg=Duel.SelectMatchingCard(tp,c64659851.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if pg:GetCount()>0 then
				Duel.SpecialSummon(pg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,c64659851.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if hg:GetCount()>0 then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end
