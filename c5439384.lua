--炎雄爆誕
---@param c Card
function c5439384.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5439384+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c5439384.target)
	e1:SetOperation(c5439384.activate)
	c:RegisterEffect(e1)
end
function c5439384.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDefense(200) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and Duel.IsExistingTarget(c5439384.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel())
end
function c5439384.filter2(c,e,tp,lv)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDefense(200) and not c:IsType(TYPE_TUNER) and c:IsLevelAbove(0) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c5439384.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+lv)
end
function c5439384.spfilter(c,e,tp,lv)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5439384.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c5439384.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c5439384.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c5439384.filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c5439384.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==2 then
		local og=Duel.GetOperatedGroup()
		local lv=og:GetSum(Card.GetLevel)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c5439384.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
