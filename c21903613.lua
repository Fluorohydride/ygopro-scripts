--森羅の舞踏娘 ピオネ
local s,id,o=GetID()
---@param c Card
function c21903613.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21903613,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21903613)
	e1:SetCondition(c21903613.condition)
	e1:SetTarget(c21903613.target)
	e1:SetOperation(c21903613.operation)
	c:RegisterEffect(e1)
	--change lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21903613,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21903613+o)
	e2:SetTarget(c21903613.lvtg)
	e2:SetOperation(c21903613.lvop)
	c:RegisterEffect(e2)
end
function c21903613.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21903613.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c21903613.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21903613.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		if ct>3 then ct=3 end
		local t={}
		for i=1,ct do t[i]=i end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21903613,2))
		ac=Duel.AnnounceNumber(tp,table.unpack(t))
	end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local og=g:Filter(c21903613.spfilter,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	if og:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(21903613,3)) then
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=og:Select(tp,1,ft,nil)
		for tc in aux.Next(sg) do
			Duel.DisableShuffleCheck()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				g:RemoveCard(tc)
			end
		end
		Duel.SpecialSummonComplete()
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
end
function c21903613.lvfilter1(c,tp,lg)
	return c:IsRace(RACE_PLANT) and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(c21903613.lvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg,c:GetLevel())
end
function c21903613.lvfilter2(c,g,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and g:IsContains(c) and not c:IsLevel(lv)
end
function c21903613.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21903613.lvfilter1(chkc,tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(c21903613.lvfilter1,tp,LOCATION_GRAVE,0,1,nil,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c21903613.lvfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp,lg)
end
function c21903613.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lg=c:GetLinkedGroup()
	local lv=tc:GetLevel()
	local g=Duel.GetMatchingGroup(c21903613.lvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg,lv)
	for lc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
	end
end
