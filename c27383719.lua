--S－Force ラプスウェル
function c27383719.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27383719,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,27383719)
	e1:SetTarget(c27383719.sptg)
	e1:SetOperation(c27383719.spop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(27383719,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27383720)
	e2:SetCost(c27383719.descost)
	e2:SetTarget(c27383719.destg)
	e2:SetOperation(c27383719.desop)
	c:RegisterEffect(e2)
end
function c27383719.spfilter(c,e,tp)
	return c:IsSetCard(0x156) and not c:IsCode(27383719)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27383719.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27383719.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c27383719.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27383719.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c27383719.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c27383719.costfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsSetCard(0x156) and c:IsAbleToRemoveAsCost()
	else
		return e:GetHandler():IsSetCard(0x156) and c:IsHasEffect(55049722,tp) and c:IsAbleToRemoveAsCost()
	end
end
function c27383719.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27383719.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c27383719.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(55049722,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
	else
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	end
end
function c27383719.ggfilter(c,tp)
	return c:IsSetCard(0x156) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c27383719.desfilter(c,tp)
	local g=c:GetColumnGroup()
	return g:IsExists(c27383719.ggfilter,1,nil,tp)
end
function c27383719.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c27383719.desfilter,tp,0,LOCATION_MZONE,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c27383719.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27383719.desfilter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.Destroy(g,REASON_EFFECT)
end
