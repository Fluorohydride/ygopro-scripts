--シンクロ・オーバーテイク
---@param c Card
function c99243014.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99243014+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99243014.cost)
	e1:SetTarget(c99243014.target)
	e1:SetOperation(c99243014.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99243014,ACTIVITY_SPSUMMON,c99243014.counterfilter)
end
function c99243014.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function c99243014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99243014,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99243014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c99243014.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function c99243014.ffilter(c,e,tp,ft)
	return c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c99243014.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,e,tp,ft)
end
function c99243014.spfilter(c,fc,e,tp,ft)
	return aux.IsMaterialListCode(fc,c:GetCode()) and (c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c99243014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c99243014.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99243014.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c99243014.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ft):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99243014.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc,e,tp,ft)
		local cc=g:GetFirst()
		if cc then
			if cc:IsAbleToHand() and (not cc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(cc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,cc)
			else
				Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
