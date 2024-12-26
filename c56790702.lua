--異次元の強襲艦
---@param c Card
function c56790702.initial_effect(c)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c56790702.atcost)
	e1:SetOperation(c56790702.atop)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56790702,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,56790702)
	e2:SetCondition(c56790702.spcon)
	e2:SetTarget(c56790702.sptg)
	e2:SetOperation(c56790702.spop)
	c:RegisterEffect(e2)
end
function c56790702.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil)
end
function c56790702.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c56790702.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,0,nil)==3
end
function c56790702.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c56790702.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
