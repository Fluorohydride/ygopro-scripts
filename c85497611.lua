--オッドアイズ・ウィザード・ドラゴン
function c85497611.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85497611,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c85497611.spcost)
	e1:SetTarget(c85497611.sptg)
	e1:SetOperation(c85497611.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85497611,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c85497611.thcon)
	e2:SetTarget(c85497611.thtg)
	e2:SetOperation(c85497611.thop)
	c:RegisterEffect(e2)
end
function c85497611.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c85497611.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,c,tp,c)
end
function c85497611.filter1(c,tp,mc)
	local g=Group.FromCards(c)
	if mc then g:AddCard(mc) end
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup()) and c:IsCode(53025096) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,g)>0
end
function c85497611.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c85497611.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c85497611.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c85497611.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c85497611.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c85497611.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c85497611.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and rp==1-tp
end
function c85497611.spfilter(c,e,tp)
	return c:IsSetCard(0x99) and not c:IsCode(85497611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c85497611.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c85497611.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c85497611.thfilter(c)
	return c:IsCode(82768499) and c:IsAbleToHand()
end
function c85497611.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c85497611.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsExistingMatchingCard(c85497611.thfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(85497611,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c85497611.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
