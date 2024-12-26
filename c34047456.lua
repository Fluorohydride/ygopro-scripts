--ギガンティック・サンダークロス
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x14) and s.filter(chkc) end
	local ct=math.abs(Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED))
	if chk==0 then return ct>0 and Duel.IsExistingTarget(s.filter,tp,0x14,0x14,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter,tp,0x14,0x14,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function s.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)<1 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then return end
	local sg=Duel.GetMatchingGroup(s.sfilter,tp,0,LOCATION_DECK,nil,e,1-tp)
	if #sg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(tg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
