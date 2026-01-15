--武装転生
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.equip_filter(e)
	return e:IsHasCategory(CATEGORY_EQUIP)
end
function s.eqfilter(c)
	return c:IsType(TYPE_EQUIP) or c:IsType(TYPE_TRAP) and c:IsOriginalEffectProperty(s.equip_filter)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,500,500,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.desfilter(c)
	return c:GetSequence()<5
end
function s.eqfilter2(c)
	return c:IsSSetable() and s.eqfilter(c)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetMatchingGroupCount(s.eqfilter,tp,LOCATION_GRAVE,0,nil)
	if ft>ct then ft=ct end
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,500,500,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local ctn=true
		while ft>0 and ctn do
			local token=Duel.CreateToken(tp,id+o)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			ft=ft-1
			if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then ctn=false end
		end
		Duel.SpecialSummonComplete()
		local c=e:GetHandler()
		if c:IsRelateToChain() then
			local dg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
			if dg:GetCount()>0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				if Duel.Destroy(dg,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsContains(c) then
					local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.eqfilter2),tp,LOCATION_GRAVE,0,nil)
					local count=Duel.GetLocationCount(tp,LOCATION_SZONE)
					if count>sg:GetCount() then count=sg:GetCount() end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
					local tg=sg:Select(tp,count,count,nil)
					Duel.BreakEffect()
					Duel.SSet(tp,tg)
					for tc in aux.Next(tg) do
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetDescription(aux.Stringid(id,3))
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
				end
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
