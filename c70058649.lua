--道化の一座『怪演』
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(s.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1dc) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function s.thfilter(c)
	return c:IsSetCard(0x1dc) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o)==0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2),1},
			{b2,aux.Stringid(id,3),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.filter(c)
	return (c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		or c:IsType(TYPE_LINK))
		and c:IsLocation(LOCATION_EXTRA)
end
function s.filter2(c)
	return c:IsLocation(LOCATION_EXTRA)
end
function s.gcheck(g,tp,eft,ect)
	return g:FilterCount(s.filter,nil)<=eft and g:FilterCount(s.filter2,nil)<=ect
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local ft=Duel.GetUsableMZoneCount(tp)
		local eft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
		if ft>0 then
			if ft>=2 then ft=2 end
			local ct=2
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
			local loc=LOCATION_DECK
			if ect>0 then loc=loc+LOCATION_EXTRA end
			local g=Duel.GetMatchingGroup(s.spfilter,tp,loc,0,nil,e,tp)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:SelectSubGroup(tp,s.gcheck,false,1,ct,tp,eft,ect)
				if sg:GetCount()>0 then
					local exg=sg:Filter(s.filter,nil)
					sg:Sub(exg)
					if exg:GetCount()>0 then
						for tc in aux.Next(exg) do
							Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
						end
					end
					local exg2=sg:Filter(s.filter2,nil)
					sg:Sub(exg2)
					if exg2:GetCount()>0 then
						for tc in aux.Next(exg2) do
							Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
						end
					end
					if sg:GetCount()>0 then
						for tc in aux.Next(sg) do
							Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
						end
					end
					Duel.SpecialSummonComplete()
				end
			end
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLocation(LOCATION_MZONE) and rc:IsSummonLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.sumfilter(c)
	return c:IsSetCard(0x1dc) and c:IsSummonable(true,nil,1)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
