--銀河天翔
---@param c Card
function c63956833.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,63956833+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c63956833.cost)
	e1:SetTarget(c63956833.target)
	e1:SetOperation(c63956833.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(63956833,ACTIVITY_SUMMON,c63956833.counterfilter)
	Duel.AddCustomActivityCounter(63956833,ACTIVITY_SPSUMMON,c63956833.counterfilter)
end
function c63956833.counterfilter(c)
	return c:IsSetCard(0x55,0x7b)
end
function c63956833.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000)
		and Duel.GetCustomActivityCount(63956833,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(63956833,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,2000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c63956833.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c63956833.splimit(e,c)
	return not c:IsSetCard(0x55,0x7b)
end
function c63956833.filter1(c,e,tp)
	return c:IsSetCard(0x55) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.IsExistingMatchingCard(c63956833.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c63956833.filter2(c,e,tp,lv)
	return c:IsSetCard(0x7b) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c63956833.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c63956833.filter1(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c63956833.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c63956833.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c63956833.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c63956833.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetLevel())
		if g:GetCount()>0 then
			g:AddCard(tc)
			for tc2 in aux.Next(g) do
				Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc2:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc2:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(2000)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc2:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
