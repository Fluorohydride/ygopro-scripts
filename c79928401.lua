--勇気の天使ヴィクトリカ
function c79928401.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79928401,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79928401)
	e1:SetTarget(c79928401.sptg)
	e1:SetOperation(c79928401.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79928401,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79928402)
	e2:SetCost(c79928401.thcost)
	e2:SetCondition(c79928401.thcon)
	e2:SetTarget(c79928401.thtg)
	e2:SetOperation(c79928401.thop)
	c:RegisterEffect(e2)
end
function c79928401.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c79928401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79928401.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c79928401.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79928401.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(math.ceil(atk*2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local lp=Duel.GetLP(tp)-tc:GetBaseAttack()
			Duel.SetLP(tp,lp)
		end
		Duel.SpecialSummonComplete()
	end
end
function c79928401.cfilter(c,tp)
	return c:IsLevelAbove(1) and c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c79928401.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c79928401.thfilter(c,lv)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and c:IsLevel(lv)
end
function c79928401.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c79928401.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c79928401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c79928401.cfilter,tp,LOCATION_GRAVE,0,c,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return cg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:Select(tp,1,1,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	local lv=tc:GetLevel()
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79928401.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79928401.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
