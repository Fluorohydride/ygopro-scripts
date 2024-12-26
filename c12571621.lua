--電脳堺豸－豸々
---@param c Card
function c12571621.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12571621,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12571621)
	e1:SetTarget(c12571621.sptg)
	e1:SetOperation(c12571621.spop)
	c:RegisterEffect(e1)
end
function c12571621.tfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x14e) and c:IsFaceup() and Duel.IsExistingMatchingCard(c12571621.tgfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c12571621.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x14e) and c:IsAbleToGrave()
end
function c12571621.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c12571621.tfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c12571621.tfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12571621.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12571621.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local type1=tc:GetType()&0x7
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c12571621.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type1)
		local tgc=g:GetFirst()
		if tgc and Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 and tgc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e)
			and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetCondition(c12571621.thcon)
			e1:SetOperation(c12571621.thop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12571621.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12571621.splimit(e,c)
	return not (c:IsLevelAbove(3) or c:IsRankAbove(3))
end
function c12571621.thfilter(c)
	return c:IsSetCard(0x14e) and c:IsType(TYPE_MONSTER) and not c:IsCode(12571621) and c:IsAbleToHand()
end
function c12571621.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c12571621.thfilter),tp,LOCATION_GRAVE,0,1,nil)
end
function c12571621.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(12571621,1)) then
		Duel.Hint(HINT_CARD,0,12571621)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12571621.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
