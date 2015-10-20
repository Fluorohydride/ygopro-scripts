--Odd-Eyes Advent
function c16494704.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16494704)
	e1:SetTarget(c16494704.RPGTarget(filter))
	e1:SetOperation(c16494704.RPGOperation(filter))
	c:RegisterEffect(e1)
end
function c16494704.pfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c16494704.exfilter0(c)
	return c:IsSetCard(0x99) and c:GetLevel()>=1 and c:IsAbleToGrave()
end
function c16494704.RPGFilter(c,filter,e,tp,m)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not c:IsRace(RACE_DRAGON)
	or not c:IsType(TYPE_RITUAL) then return false end
	local result=false
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
		m:AddCard(c)
	else
		result=m:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
	end
	return result
end
function c16494704.RPGTarget(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetMatchingGroup(c16494704.pfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
						if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
							local sg=Duel.GetMatchingGroup(c16494704.exfilter0,tp,LOCATION_EXTRA,0,nil)
							mg:Merge(sg)
						end
					return Duel.IsExistingMatchingCard(c16494704.RPGFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,filter,e,tp,mg)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function c16494704.RPGOperation(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetMatchingGroup(c16494704.pfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
						if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
							local sg=Duel.GetMatchingGroup(c16494704.exfilter0,tp,LOCATION_EXTRA,0,nil)
							mg:Merge(sg)
						end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,c16494704.RPGFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,filter,e,tp,mg)
				if tg:GetCount()>0 then
					local tc=tg:GetFirst()
					mg:RemoveCard(tc)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
					tc:SetMaterial(mat)
					if tc:IsLocation(LOCATION_MZONE) then
						Duel.ReleaseRitualMaterial(mat)
					else
						Duel.SendtoGrave(mat,REASON_EFFECT)
					end
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end