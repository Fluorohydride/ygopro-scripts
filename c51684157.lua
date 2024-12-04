--天幻の龍輪
function c51684157.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51684157,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,51684157)
	e1:SetCost(c51684157.cost)
	e1:SetTarget(c51684157.target)
	e1:SetOperation(c51684157.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51684157,1))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51684157)
	e2:SetCondition(c51684157.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c51684157.thtg)
	e2:SetOperation(c51684157.thop)
	c:RegisterEffect(e2)
end
function c51684157.filter(c,e,tp,check)
	return c:IsRace(RACE_WYRM) and (Duel.IsExistingMatchingCard(c51684157.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		or (check and not c:IsType(TYPE_EFFECT)
		and Duel.IsExistingMatchingCard(c51684157.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true)
		and Duel.GetMZoneCount(tp,c)>0))
end
function c51684157.thfilter(c,e,tp,check)
	return c:IsRace(RACE_WYRM) and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c51684157.thfilter2(c,e,tp,ft,check)
	return c:IsRace(RACE_WYRM) and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0))
end
function c51684157.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c51684157.filter,1,nil,e,tp,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c51684157.filter,1,1,nil,e,tp,true)
	if not g:GetFirst():IsType(TYPE_EFFECT) then e:SetLabel(100,1) end
	Duel.Release(g,REASON_COST)
end
function c51684157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=true
	local l1,l2=e:GetLabel()
	if chk==0 then
		if l1~=100 then check=false end
		e:SetLabel(0,0)
		return Duel.IsExistingMatchingCard(c51684157.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
	if l2==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	end
end
function c51684157.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=false
	local l1,l2=e:GetLabel()
	if l2==1 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then check=true end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c51684157.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft,check)
	local tc=g:GetFirst()
	if tc then
		if not check or (tc:IsAbleToHand() and (ft<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			or Duel.SelectOption(tp,1190,1152)==0)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c51684157.ffilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c51684157.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51684157.ffilter,tp,LOCATION_MZONE,0,1,nil)
end
function c51684157.cfilter(c)
	return c:IsSetCard(0x12c) and c:IsAbleToHand()
end
function c51684157.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51684157.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51684157.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51684157.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
