--ヤミー☆サプライズ
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.thfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1ca) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.thfilter2(c)
	return c:IsFaceupEx() and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=(Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked()) and
		Duel.IsExistingTarget(s.thfilter1,tp,LOCATION_MZONE,0,2,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,2,nil)
	local b2=(Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b3=(Duel.GetFlagEffect(tp,id+2*o)==0 or not e:IsCostChecked())
		and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_FZONE+LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2},
		{b3,aux.Stringid(id,3),3})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectTarget(tp,s.thfilter1,tp,LOCATION_MZONE,0,2,2,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,2,2,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_FZONE+LOCATION_GRAVE)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id+2*o,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.tffilter(c,tp)
	return c:IsSetCard(0x1ca) and c:IsAllTypes(TYPE_FIELD+TYPE_SPELL)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local tg=Duel.GetTargetsRelateToChain()
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--cannot atk directly this turn
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_FZONE+LOCATION_GRAVE,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.HintSelection(tg)
			local tc=tg:GetFirst()
			if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,tc)
				local fg=Duel.GetMatchingGroup(s.tffilter,tp,LOCATION_HAND,0,nil,tp)
				local tfc=nil
				::cancel::
				if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
					local tfg=fg:CancelableSelect(tp,1,1,nil)
					if not tfg then goto cancel end
					tfc=tfg:GetFirst()
				end
				Duel.ShuffleHand(tp)
				if tfc then
					Duel.BreakEffect()
					local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
					if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
					Duel.MoveToField(tfc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				end
			end
		end
	end
end
