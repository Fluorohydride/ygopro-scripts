--第19層『襲来干渉！漆黒の超量士！！』
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc)
end
function s.attfilter(c,att)
	return c:IsFaceup() and c:GetOriginalAttribute()&att~=0
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xdc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and not Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,0,1,nil,c:GetOriginalAttribute())
end
function s.setfilter(c)
	return c:IsSetCard(0xdc) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetLabel()==1 and chkc:IsType(TYPE_MONSTER) and s.posfilter(chkc) end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	local b1=Duel.IsExistingTarget(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (not e:IsCostChecked()
			or Duel.GetFlagEffect(tp,id+o)==0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil))
	local b3=ct>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o*2)==0)
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
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(CATEGORY_POSITION)
		end
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		Duel.SelectTarget(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif op==2 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==3 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(0)
		end
		e:SetProperty(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() and tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	elseif e:GetLabel()==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	elseif e:GetLabel()==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
