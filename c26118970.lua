--レッドローズ・ドラゴン
function c26118970.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26118970,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,26118970)
	e1:SetCondition(c26118970.spcon)
	e1:SetTarget(c26118970.sptg)
	e1:SetOperation(c26118970.spop)
	c:RegisterEffect(e1)
end
function c26118970.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c26118970.spfilter(c,e,tp)
	return c:IsSetCard(0x123) and not c:IsCode(26118970) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26118970.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26118970.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	local rc=e:GetHandler():GetReasonCard()
	if rc and (rc:IsCode(73580471) or (rc:IsRace(RACE_PLANT) and rc:IsType(TYPE_SYNCHRO))) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c26118970.thfilter(c)
	return c:IsCode(53503015,99092624) and c:IsAbleToHand()
end
function c26118970.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26118970.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetLabel()==1
		and Duel.IsExistingMatchingCard(c26118970.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(26118970,1)) then
		local g2=Duel.SelectMatchingCard(tp,c26118970.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
