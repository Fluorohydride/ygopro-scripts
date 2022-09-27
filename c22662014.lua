--驚楽園の助手 ＜Delia＞
function c22662014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22662014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22662014)
	e1:SetCost(c22662014.spcost)
	e1:SetTarget(c22662014.sptg)
	e1:SetOperation(c22662014.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22662014,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22662015)
	e2:SetCost(c22662014.setcost)
	e2:SetTarget(c22662014.settg)
	e2:SetOperation(c22662014.setop)
	c:RegisterEffect(e2)
end
function c22662014.cfilter(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and not c:IsPublic()
end
function c22662014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22662014.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c22662014.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c22662014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22662014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22662014.costfilter(c,ft)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_TRAP) and c:IsSetCard(0x15c) and c:IsAbleToGraveAsCost()
		and (ft>0 or c:IsLocation(LOCATION_SZONE) and ft>-1)
end
function c22662014.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c22662014.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22662014.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22662014.setfilter(c,chk)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and c:IsSSetable(chk)
end
function c22662014.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22662014.setfilter,tp,LOCATION_DECK,0,1,nil,true) end
end
function c22662014.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22662014.setfilter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
