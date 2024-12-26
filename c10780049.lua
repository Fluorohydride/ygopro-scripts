--ピュアリィ・シェアリィ！？
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x18c) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.xyzspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank(),c:GetAttribute(),nil)
end
function s.xyzspfilter(c,e,tp,rk,att,mc)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_XYZ) and c:IsRank(rk) and not c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.deckspfilter(c,e,tp)
	return c:IsSetCard(0x18c) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzfilter1(c,tp)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_QUICKPLAY)
end
function s.xyzfilter2(c,og)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_QUICKPLAY) and c:IsCanOverlay()
		and og:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.deckspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.deckspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local sc1=g1:GetFirst()
	if not sc1 then return end
	Duel.SpecialSummonStep(sc1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc1:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.xyzspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc:GetAttribute(),sc1)
	local sc2=g2:GetFirst()
	if sc2 then
		sc2:SetMaterial(Group.FromCards(sc1))
		Duel.Overlay(sc2,Group.FromCards(sc1))
		Duel.SpecialSummon(sc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc2:CompleteProcedure()
		local og=tc:GetOverlayGroup():Filter(s.xyzfilter1,nil,tp)
		local g=Duel.GetMatchingGroup(s.xyzfilter2,tp,LOCATION_DECK,0,nil,og)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:Select(tp,1,1,nil)
			Duel.Overlay(sc2,sg:GetFirst())
		end
	end
end
