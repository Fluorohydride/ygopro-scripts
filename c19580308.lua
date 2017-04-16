--DDラミア
function c19580308.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19580308,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,19580308)
	e1:SetCost(c19580308.cost)
	e1:SetTarget(c19580308.target)
	e1:SetOperation(c19580308.operation)
	c:RegisterEffect(e1)
end
function c19580308.cfilter(c,ft)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and (c:IsSetCard(0xaf) or c:IsSetCard(0xae))
		and not c:IsCode(19580308) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c19580308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c19580308.cfilter,tp,loc,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19580308.cfilter,tp,loc,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c19580308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19580308.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
