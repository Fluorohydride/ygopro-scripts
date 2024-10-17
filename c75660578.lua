--死の王 ヘル
---@param c Card
function c75660578.initial_effect(c)
	c:SetUniqueOnField(1,0,75660578)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75660578,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75660578)
	e1:SetCost(c75660578.spcost)
	e1:SetTarget(c75660578.sptg)
	e1:SetOperation(c75660578.spop)
	c:RegisterEffect(e1)
end
function c75660578.costfilter(c,e,tp)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_ZOMBIE)) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c75660578.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c75660578.spfilter(c,e,tp,code)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_ZOMBIE)) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c75660578.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c75660578.costfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c75660578.costfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c75660578.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:GetLabel()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c75660578.spfilter(chkc,e,tp,code) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c75660578.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c75660578.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
