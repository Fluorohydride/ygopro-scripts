--アマゾネスの鎖使い－死に際の鎖舞い－
local s,id,o=GetID()
if not CATEGORY_DECK_SPSUMMON then
	CATEGORY_DECK_SPSUMMON=0x800000000
end
function s.initial_effect(c)
	--To grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECK_SPSUMMON+CATEGORY_HANDES_OPPO+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.cfilter(c)
	return c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function s.spfilter(c)
	return c:IsLevel(10) and c:IsType(TYPE_MONSTER)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,1,nil,e,tp)
		and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if tc then
				Duel.ConfirmCards(tp,tc)
				local flag=tc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp)
					and (tc:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
						or tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0)
				if flag and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CANNOT_TRIGGER)
						e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e1)
						Duel.SpecialSummonComplete()
					end
				elseif tc:IsLocation(LOCATION_DECK) then
					Duel.ShuffleDeck(1-tp)
				end
			end
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_HAND,nil,REASON_EFFECT)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	end
end
