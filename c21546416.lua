--アームド・ドラゴン・サンダー LV5
function c21546416.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,46384672,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21546416,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21546416)
	e2:SetCost(c21546416.spcost)
	e2:SetTarget(c21546416.sptg)
	e2:SetOperation(c21546416.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21546416,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,21546417)
	e3:SetCondition(c21546416.thcon)
	e3:SetTarget(c21546416.thtg)
	e3:SetOperation(c21546416.thop)
	c:RegisterEffect(e3)
end
c21546416.lvup={46384672}
c21546416.lvdn={57030525}
function c21546416.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c21546416.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,e:GetLabel())
end
function c21546416.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:IsCode(46384672) then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
		return Duel.IsExistingMatchingCard(c21546416.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21546416.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c21546416.spfilter(c,e,tp,label)
	return c:IsSetCard(0x111) and c:IsLevelBelow(7)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or label==1 and c:IsCode(73879377) and c:IsCanBeSpecialSummoned(e,0,tp,true,false))
end
function c21546416.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:IsCode(46384672) then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
		return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
			and Duel.IsExistingMatchingCard(c21546416.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,e:GetLabel())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c21546416.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0 then
		local label=e:GetLabel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c21546416.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,label)
		local tc=g:GetFirst()
		if tc then
			if label==1 and tc:IsCode(73879377) and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c21546416.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)&RACE_DRAGON>0
end
function c21546416.thfilter(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function c21546416.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21546416.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21546416.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21546416.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
