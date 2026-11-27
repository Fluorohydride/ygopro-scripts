--電脳堺虎－虎々
function c95243515.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c95243515.efcon1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95243515.efcon2)
	e2:SetValue(c95243515.immval)
	c:RegisterEffect(e2)
	--Effect 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95243515,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCost(c95243515.discost)
	e3:SetTarget(c95243515.distg)
	e3:SetOperation(c95243515.disop)
	c:RegisterEffect(e3)
end
function c95243515.efcon1(e)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,0x114e)
	return ct>=2
end
function c95243515.efcon2(e)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,0x114e)
	return ct==4
end
function c95243515.immval(e,re)
	local rc=re:GetHandler()
	return re:IsActivated() and not rc:IsSetCard(0x14e)
end
function c95243515.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95243515.filter1(c,tp)
	return c:IsType(TYPE_EFFECT) and aux.NegateEffectMonsterFilter(c)
		and Duel.IsExistingTarget(c95243515.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c)
end
function c95243515.filter2(c,tc)
	return c:IsType(TYPE_EFFECT) and aux.NegateEffectMonsterFilter(c)
		and not c:IsRace(tc:GetRace()) and not c:IsAttribute(tc:GetAttribute())
end
function c95243515.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c95243515.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g1=Duel.SelectTarget(tp,c95243515.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g2=Duel.SelectTarget(tp,c95243515.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst(),g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,#g1,0,0)
end
function c95243515.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		if tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
