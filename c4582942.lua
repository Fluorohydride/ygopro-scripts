--律導のヴァルモニカ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a3) and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a3) and c:IsType(TYPE_LINK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,op)
	if op==nil and not s.condition(e,tp) then return end
	if op==nil then
		local chk=Duel.IsExistingMatchingCard(s.afilter,tp,LOCATION_MZONE,0,1,nil)
		op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(id,1)},
			{true,aux.Stringid(id,2)},
			{chk,aux.Stringid(id,3)})
	end
	if op&1>0 and Duel.Recover(tp,500,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
		if op==3 then Duel.BreakEffect() end
	end
	if op&2>0 and Duel.Damage(tp,500,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
