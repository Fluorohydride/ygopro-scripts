--光翼の竜
function c82190203.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82190203+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c82190203.condition)
	e1:SetTarget(c82190203.target)
	e1:SetOperation(c82190203.activate)
	c:RegisterEffect(e1)
end
function c82190203.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c82190203.cfilter(c)
	return c:IsCode(13331639) and c:IsFaceup()
end
function c82190203.filter(c,e,tp,check)
	return c:IsSetCard(0x10f8,0x20f8) and c:IsType(TYPE_PENDULUM) and (c:IsAbleToHand()
		or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c82190203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c82190203.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		return Duel.IsExistingMatchingCard(c82190203.filter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
end
function c82190203.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82190203.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c82190203.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local b=check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if tc:IsAbleToHand() and (not b or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
