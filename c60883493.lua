--VS 裏螺旋流雪風
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,3)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RaiseEvent(sg,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
	e:SetLabel(#sg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function s.sfilter(c,e,tp)
	return c:IsSetCard(0x195) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 and Duel.Damage(1-tp,400,REASON_EFFECT)>0 and Duel.GetLP(1-tp)>0 then
		local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if ct>1 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,600,REASON_EFFECT)
		if Duel.GetLP(1-tp)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x195))
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if ct>2 then
		Duel.BreakEffect()
		if Duel.Damage(1-tp,800,REASON_EFFECT)>0 and Duel.GetLP(1-tp)>0 then
			local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
