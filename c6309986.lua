--ティンクル・ファイブスター
function c6309986.initial_effect(c)
	aux.AddCodeList(c,44632120,71036835,7021574,34419588,40640057)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,6309986+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c6309986.cost)
	e1:SetTarget(c6309986.target)
	e1:SetOperation(c6309986.activate)
	c:RegisterEffect(e1)
end
c6309986.spchecks=aux.CreateChecks(Card.IsCode,{44632120,71036835,7021574,34419588,40640057})
function c6309986.cfilter(c,tp)
	return c:IsFaceup() and c:IsLevel(5) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>=5
end
function c6309986.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=1 then return false end
	local rc=Duel.GetFirstMatchingCard(c6309986.cfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return rc end
	Duel.Release(rc,REASON_COST)
end
function c6309986.spfilter(c,e,tp)
	return c:IsCode(44632120,71036835,7021574,34419588,40640057) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6309986.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>=5
	if chk==0 then
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(c6309986.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return res and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:CheckSubGroupEach(c6309986.spchecks)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c6309986.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=5 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c6309986.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroupEach(tp,c6309986.spchecks,false)
		if sg then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(1)
				tc:RegisterEffect(e1,true)
			end
		end
	end
end
