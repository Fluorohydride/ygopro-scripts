--次元誘爆
---@param c Card
function c1896112.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1896112.cost)
	e1:SetTarget(c1896112.target)
	e1:SetOperation(c1896112.operation)
	c:RegisterEffect(e1)
end
function c1896112.cfilter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost() and (ft>0 or c:GetSequence()<5)
end
function c1896112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c1896112.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1896112.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
end
function c1896112.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1896112.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1896112.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c1896112.filter,1-tp,LOCATION_REMOVED,0,1,nil,e,1-tp) end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
	if ft1>2 then ft1=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c1896112.filter,tp,LOCATION_REMOVED,0,1,ft1,nil,e,tp)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft2>2 then ft2=2 end
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(1-tp,c1896112.filter,1-tp,LOCATION_REMOVED,0,1,ft2,nil,e,1-tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,0)
end
function c1896112.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct1=g1:GetCount()
	if ft1>=ct1 and (ct1==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) then
		local tc=g1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g1:GetNext()
		end
	end
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct2=g2:GetCount()
	if ft2>=ct2 and (ct2==1 or not Duel.IsPlayerAffectedByEffect(1-tp,59822133)) then
		local tc=g2:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
			tc=g2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
end
