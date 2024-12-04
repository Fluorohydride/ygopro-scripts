--しらうおの軍貫
function c78362751.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78362751,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,78362751)
	e1:SetCondition(c78362751.spcon)
	e1:SetTarget(c78362751.sptg)
	e1:SetOperation(c78362751.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78362751,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,78362752)
	e2:SetTarget(c78362751.sptg2)
	e2:SetOperation(c78362751.spop2)
	c:RegisterEffect(e2)
end
function c78362751.cfilter(c)
	if c:IsFacedown() then return false end
	local oc=c:GetOverlayGroup()
	return c:IsCode(24639891) or c:IsType(TYPE_XYZ) and oc and oc:IsExists(Card.IsCode,1,nil,24639891)
end
function c78362751.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78362751.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c78362751.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78362751.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c78362751.spfilter(c,e,tp)
	return c:IsSetCard(0x166) and not c:IsCode(78362751) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78362751.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78362751.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c78362751.filter(c)
	return c:IsCode(24639891) and c:IsAbleToDeck()
end
function c78362751.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c78362751.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c78362751.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(78362751,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=sg:Select(tp,1,#sg,nil)
			Duel.BreakEffect()
			local tc=dg:GetFirst()
			while tc do
				if tc:IsLocation(LOCATION_GRAVE) then
					Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
				end
				Duel.MoveSequence(tc,SEQ_DECKTOP)
				tc=dg:GetNext()
			end
			Duel.SortDecktop(tp,tp,#dg)
		end
	end
end
