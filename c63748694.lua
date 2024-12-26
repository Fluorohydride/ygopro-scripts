--赤しゃりの軍貫
---@param c Card
function c63748694.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,24639891,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,63748694)
	e1:SetCost(c63748694.spcost)
	e1:SetTarget(c63748694.sptg)
	e1:SetOperation(c63748694.spop)
	c:RegisterEffect(e1)
end
function c63748694.cfilter(c)
	return c:IsCode(24639891) and not c:IsPublic()
end
function c63748694.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63748694.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c63748694.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c63748694.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c63748694.filter(c,e,tp,oc)
	return c:IsSetCard(0x166) and not c:IsCode(24639891) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c63748694.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,oc,c)
end
function c63748694.xyzfilter(c,e,tp,oc,mc)
	return c:IsType(TYPE_XYZ) and aux.IsCodeListed(c,mc:GetCode())
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and oc:IsCanBeXyzMaterial(c) and mc:IsCanBeXyzMaterial(c)
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(oc,mc),c)>0
		and aux.MustMaterialCheck(Group.FromCards(oc,mc),tp,EFFECT_MUST_BE_XMATERIAL)
end
function c63748694.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c63748694.filter,tp,LOCATION_DECK,0,nil,e,tp,c)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(63748694,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		sc:RegisterEffect(e2)
		Duel.AdjustAll()
		local g=Group.FromCards(c,sc)
		if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xyzg=Duel.GetMatchingGroup(c63748694.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,c,sc)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			xyz:SetMaterial(g)
			Duel.Overlay(xyz,g)
			Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			xyz:CompleteProcedure()
		end
	end
end
