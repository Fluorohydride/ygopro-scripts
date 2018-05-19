--妨げられた壊獣の眠り
function c99330325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99330325,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99330325+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99330325.target)
	e1:SetOperation(c99330325.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99330325,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c99330325.thtg)
	e2:SetOperation(c99330325.thop)
	c:RegisterEffect(e2)
end
function c99330325.chkfilter1(c,e,tp)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and 
		not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c)
		and Duel.IsExistingMatchingCard(c99330325.chkfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99330325.chkfilter2(c,e,tp,cd)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
		and not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,1-tp,c)
end
function c99330325.filter1(c,e,tp)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c99330325.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99330325.filter2(c,e,tp,cd)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function c99330325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
		and Duel.IsExistingMatchingCard(c99330325.chkfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c99330325.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local sg=Duel.GetMatchingGroup(c99330325.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99330325,2))
		local g1=sg:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99330325,3))
		local g2=Duel.SelectMatchingCard(tp,c99330325.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_MUST_ATTACK)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
function c99330325.thfilter(c)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99330325.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99330325.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99330325.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99330325.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
