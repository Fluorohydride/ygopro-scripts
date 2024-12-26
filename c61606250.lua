--武装竜の襲雷
---@param c Card
function c61606250.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,61606250+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c61606250.cost)
	e1:SetTarget(c61606250.target)
	e1:SetOperation(c61606250.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(61606250,ACTIVITY_SPSUMMON,c61606250.counterfilter)
end
function c61606250.counterfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c61606250.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(61606250,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c61606250.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c61606250.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DRAGON)
end
function c61606250.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x111) and Duel.IsExistingMatchingCard(c61606250.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c61606250.thfilter(c,e,tp,code)
	if not (c:IsCode(code) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false))
end
function c61606250.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c61606250.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c61606250.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c61606250.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c61606250.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c61606250.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sc=g:GetFirst()
		if sc then
			if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,true,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			else
				if Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
