--ウォークライ・フォティア
function c83286340.initial_effect(c)
	--tohand & atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83286340,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,83286340)
	e1:SetTarget(c83286340.thtg)
	e1:SetOperation(c83286340.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83286340,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,83286341)
	e2:SetCondition(c83286340.spcon)
	e2:SetTarget(c83286340.sptg)
	e2:SetOperation(c83286340.spop)
	c:RegisterEffect(e2)
end
function c83286340.thfilter(c)
	return c:IsSetCard(0x15f) and not c:IsCode(83286340) and c:IsAbleToHand()
end
function c83286340.check(c,tp)
	return c and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c83286340.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (c83286340.check(Duel.GetAttacker(),tp) or c83286340.check(Duel.GetAttackTarget(),tp))
		and Duel.IsExistingMatchingCard(c83286340.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c83286340.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c83286340.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c83286340.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c83286340.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c83286340.atkfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(c83286340.atkfilter,tp,LOCATION_MZONE,0,nil)
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1:SetValue(200)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c83286340.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c83286340.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0x15f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83286340.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c83286340.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c83286340.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c83286340.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
