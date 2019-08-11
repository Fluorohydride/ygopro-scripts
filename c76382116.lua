--鉄の王 ドヴェルグス
function c76382116.initial_effect(c)
	c:SetUniqueOnField(1,0,76382116)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76382116,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,76382116)
	e1:SetCost(c76382116.spcost)
	e1:SetTarget(c76382116.sptg)
	e1:SetOperation(c76382116.spop)
	c:RegisterEffect(e1)
end
function c76382116.spfilter(c,e,tp,g)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_MACHINE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c76382116.costfilter1(c,e,tp)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_MACHINE)) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c76382116.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,Group.FromCards(c))
end
function c76382116.costfilter2(c,e,tp)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_MACHINE))
		and Duel.IsExistingMatchingCard(c76382116.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,Group.FromCards(c))
end
function c76382116.fselect(g,e,tp)
	local sg=Duel.GetMatchingGroup(c76382116.spfilter,tp,LOCATION_HAND,0,nil,e,tp,g)
	if sg:CheckSubGroup(aux.dncheck,g:GetCount(),g:GetCount()) and Duel.GetMZoneCount(tp,g)>=g:GetCount() then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c76382116.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c76382116.costfilter1,1,nil,e,tp) end
	local rg=Duel.GetReleaseGroup(tp):Filter(c76382116.costfilter2,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c76382116.fselect,false,1,99,e,tp)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.Release(sg,REASON_COST)
end
function c76382116.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),tp,LOCATION_HAND)
end
function c76382116.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<g:GetCount() then return end
	local sg=Duel.GetMatchingGroup(c76382116.spfilter,tp,LOCATION_HAND,0,nil,e,tp,g)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,aux.dncheck,false,g:GetCount(),g:GetCount())
	if tg and tg:GetCount()>0 then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
