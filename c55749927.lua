--オリファンの角笛
function c55749927.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,55749927+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c55749927.target)
	e1:SetOperation(c55749927.activate)
	c:RegisterEffect(e1)
end
function c55749927.rmfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() or c:GetEquipTarget())
		and (c:GetType()&(TYPE_EQUIP+TYPE_SPELL))==TYPE_EQUIP+TYPE_SPELL
		and c:IsAbleToRemove()
end
function c55749927.desfilter(c,tp,g)
	local ft=math.min((Duel.GetMZoneCount(tp,c)),3)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return c:IsFaceup() and c:IsSetCard(0x148)
		and (not g or ft>0 and g:CheckWithSumEqual(Card.GetLevel,9,1,ft))
end
function c55749927.spfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelBelow(9)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55749927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c55749927.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c55749927.desfilter,tp,LOCATION_MZONE,0,nil,tp)
	local b1=Duel.IsExistingMatchingCard(c55749927.rmfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
	local b2=g:GetCount()>0 and Duel.IsExistingMatchingCard(c55749927.desfilter,tp,LOCATION_MZONE,0,1,nil,tp,g)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(55749927,0),aux.Stringid(55749927,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(55749927,0))
	else op=Duel.SelectOption(tp,aux.Stringid(55749927,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c55749927.spcheck(g)
	return g:GetSum(Card.GetLevel)==9
end
function c55749927.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c55749927.rmfilter),tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
		local exc=nil
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc)
			and Duel.SelectYesNo(tp,aux.Stringid(55749927,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	else
		local g=Duel.GetMatchingGroup(c55749927.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c55749927.desfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,g)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			if Duel.Destroy(dg,REASON_EFFECT)~=0 then
				local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
				if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				g=Duel.GetMatchingGroup(c55749927.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
				if ft>0 and g:CheckWithSumEqual(Card.GetLevel,9,1,ft) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:SelectSubGroup(tp,c55749927.spcheck,false,1,ft)
					if sg then
						local tc=sg:GetFirst()
						for tc in aux.Next(sg) do
							if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
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
						end
						Duel.SpecialSummonComplete()
					end
				end
			end
		end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetTargetRange(1,0)
		e3:SetTarget(c55749927.splimit)
		if Duel.GetTurnPlayer()==tp then
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e3,tp)
	end
end
function c55749927.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end
