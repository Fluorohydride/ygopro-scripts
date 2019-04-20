--救魔の奇石
function c46984349.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c46984349.cost)
	e1:SetTarget(c46984349.target)
	e1:SetOperation(c46984349.activate)
	c:RegisterEffect(e1)
end
function c46984349.costfilter(c,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost()
		and Duel.GetMZoneCount(tp,c)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,46984349,0,0x11,0,0,c:GetOriginalLevel(),RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
end
function c46984349.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46984349.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c46984349.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
end
function c46984349.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c46984349.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,46984349,0,0x11,0,0,lv,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,0,0,lv,0,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
