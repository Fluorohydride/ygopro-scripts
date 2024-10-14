--Sin パラドクスギア
---@param c Card
function c48829461.initial_effect(c)
	--sin territory
	c:SetUniqueOnField(1,1,c48829461.uqfilter,LOCATION_MZONE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,48829461)
	e1:SetCondition(c48829461.condition)
	e1:SetCost(c48829461.cost)
	e1:SetTarget(c48829461.target)
	e1:SetOperation(c48829461.operation)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(48829461)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,48829462)
	c:RegisterEffect(e2)
end
function c48829461.sfilter(c)
	return c:IsOriginalCodeRule(598988,1710476,9433350,36521459,37115575,55343236) and not c:IsDisabled()
end
function c48829461.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),75223115)
		and Duel.IsExistingMatchingCard(c48829461.sfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		return c:IsCode(48829461)
	else
		return false
	end
end
function c48829461.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c48829461.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c48829461.spfilter(c,e,tp)
	return c:IsCode(74509280) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c48829461.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c48829461.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x23) and c:IsAbleToHand() and not c:IsCode(48829461)
end
function c48829461.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c48829461.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c48829461.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c48829461.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c48829461.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
