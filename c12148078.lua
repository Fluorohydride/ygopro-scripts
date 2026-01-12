--SRルーレット
function c12148078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12148078+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12148078.cost)
	e1:SetTarget(c12148078.target)
	e1:SetOperation(c12148078.activate)
	c:RegisterEffect(e1)
end
function c12148078.cfilter(c,e,tp)
	return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c12148078.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,6)
end
function c12148078.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x2016) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12148078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c12148078.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c12148078.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c12148078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==100
		e:SetLabel(0)
		return res or Duel.IsExistingMatchingCard(c12148078.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,6)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c12148078.fselect(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function c12148078.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	local res=false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		if ft>2 then ft=2 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c12148078.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,dc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c12148078.fselect,false,1,ft,dc)
		if sg then
			for tc in aux.Next(sg) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
			res=true
		end
	end
	if not res then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-dc*500)
	end
end
