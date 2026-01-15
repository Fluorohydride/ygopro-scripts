--三位一体
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)<Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
		and Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=tp
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,3,3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thfilter1(c,tp)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsFaceup()
		and Duel.IsExistingTarget(s.thfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
function s.thfilter2(c,tp,oc)
	return not c:IsOriginalCodeRule(oc:GetOriginalCode()) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsFaceup()
		and Duel.IsExistingTarget(s.thfilter3,tp,LOCATION_ONFIELD,0,1,nil,tp,oc,c)
end
function s.thfilter3(c,tp,oc,tc)
	return not c:IsOriginalCodeRule(oc:GetOriginalCode(),tc:GetOriginalCode()) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp,oc,tc,c)
end
function s.setfilter(c,tp,oc,tc,sc)
	return aux.IsCodeListed(c,oc:GetOriginalCode()) and aux.IsCodeListed(c,tc:GetOriginalCode()) and aux.IsCodeListed(c,sc:GetOriginalCode())
		and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.thfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local oc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,s.thfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,tp,oc)
	local tc=g2:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.thfilter3,tp,LOCATION_ONFIELD,0,1,1,nil,tp,oc,tc)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if tg:GetCount()~=3 then return end
	local oc=tg:GetFirst()
	local tc=tg:GetNext()
	local sc=tg:GetNext()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp,oc,tc,sc)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
