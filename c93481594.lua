--幸せの多重奏
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.gcheck(g)
	return g:GetClassCount(Card.GetCurrentScale)==2
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=g:CheckSubGroup(s.gcheck,2,2)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c,REASON_EFFECT)
		and (not e:IsCostChecked()
			or Duel.GetFlagEffect(tp,id)==0)
	local b2=Duel.GetFlagEffect(tp,id+o*3)==0
		and (not e:IsCostChecked()
			or Duel.GetFlagEffect(tp,id+o)==0)
	local b3=not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_PZONE,0,2,nil,e,tp)
		and (not e:IsCostChecked()
			or Duel.GetFlagEffect(tp,id+o*2)==0)
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 or b2 or b3 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_HANDES|CATEGORY_SEARCH|CATEGORY_TOHAND|CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(0)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==3 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_PZONE)
	end
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return end
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #g>0 and g:CheckSubGroup(s.gcheck,2,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=g:SelectSubGroup(tp,s.gcheck,false,2,2)
			if ag then
				Duel.SendtoHand(ag,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ag)
				local dt=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<=0 then return end
				if ft>dt+1 then ft=dt+1 end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				if Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
					if sg:GetCount()>0 then
						Duel.BreakEffect()
						Duel.ShuffleHand(tp)
						Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
	elseif e:GetLabel()==2 then
		if Duel.GetFlagEffect(tp,id+o*3)~=0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,5))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCountLimit(1,id)
		e1:SetValue(s.pendvalue)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id+o*3,RESET_PHASE+PHASE_END,0,1)
	elseif e:GetLabel()==3 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_PZONE,0,nil,e,tp)
		if g:GetCount()>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,2,2,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.pendvalue(e,c)
	return c:IsSetCard(0x162)
end
