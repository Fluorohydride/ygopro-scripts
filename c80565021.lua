--Angelechy Opening to e4
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnCount()==1 and Duel.GetTurnPlayer()==1-tp
		and Duel.GetCurrentPhase()==PHASE_STANDBY
end
function s.stfilter(c,tp)
	return c:IsSetCard(0x1e2) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.setfilter(c,tp)
	return c:IsSetCard(0x1e2) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
		and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function s.spfilter(c,e,tp,pchk)
	return c:IsLevel(2,7) and c:IsSetCard(0x1e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
		and (not pchk or Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_EXTRA,0,1,c,tp))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,true)
		and ((e:GetHandler():IsLocation(LOCATION_ONFIELD) or not e:IsCostChecked()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			or e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.stfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
			if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,true) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
				if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)~=0 then
					if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
						local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
						local sc=sg:GetFirst()
						if sc then
							Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
							local e1=Effect.CreateEffect(c)
							e1:SetCode(EFFECT_CHANGE_TYPE)
							e1:SetType(EFFECT_TYPE_SINGLE)
							e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
							e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
							e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
							sc:RegisterEffect(e1)
						end
					end
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,false)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
				end
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		local ct=1
		if Duel.GetTurnPlayer()==tp then
			ct=2
		end
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
