--堕天使降臨
function c58787301.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c58787301.cost)
	e1:SetTarget(c58787301.target)
	e1:SetOperation(c58787301.activate)
	c:RegisterEffect(e1)
end
function c58787301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c58787301.cfilter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(c58787301.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c58787301.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xef) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c58787301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c58787301.cfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c58787301.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),2)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,c58787301.cfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local lv=g:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c58787301.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp,lv)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
