--古衛兵アギド
function c62320425.initial_effect(c)
	aux.AddCodeList(c,17484499)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62320425,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,62320425)
	e1:SetCondition(c62320425.spcon)
	e1:SetTarget(c62320425.sptg)
	e1:SetOperation(c62320425.spop)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62320425,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62320426)
	e2:SetCondition(c62320425.discon)
	e2:SetTarget(c62320425.distg)
	e2:SetOperation(c62320425.disop)
	c:RegisterEffect(e2)
end
function c62320425.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK) and c:IsControler(1-tp)
end
function c62320425.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c62320425.cfilter,1,nil,tp)
end
function c62320425.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c62320425.spfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(4) and not c:IsCode(62320425)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62320425.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c62320425.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(62320425,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c62320425.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_DECK)
end
function c62320425.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,5)
end
function c62320425.disop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,5)
	local g2=Duel.GetDecktopGroup(1-tp,5)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,17484499) then
		local off=1
		local ops={}
		local opval={}
		if Duel.IsPlayerCanDiscardDeck(tp,5) then
			ops[off]=aux.Stringid(62320425,4)
			opval[off-1]=tp
			off=off+1
		end
		if Duel.IsPlayerCanDiscardDeck(1-tp,5) then
			ops[off]=aux.Stringid(62320425,5)
			opval[off-1]=1-tp
			off=off+1
		end
		ops[off]=aux.Stringid(62320425,6)
		opval[off-1]=-1
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel~=-1 then
			Duel.BreakEffect()
			Duel.DiscardDeck(sel,5,REASON_EFFECT)
		end
	end
end
