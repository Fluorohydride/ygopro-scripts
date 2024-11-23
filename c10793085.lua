--鉄獣の咆哮
---@param c Card
function c10793085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCountLimit(1,10793085+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10793085.condition)
	e1:SetTarget(c10793085.target)
	e1:SetOperation(c10793085.activate)
	c:RegisterEffect(e1)
end
function c10793085.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c10793085.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10793085.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10793085.costfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x14d)
		and Duel.IsExistingTarget(c10793085.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetType())
end
function c10793085.tgfilter(c,type)
	if type==nil then return false end
	if not (c:IsFaceup() and c:IsType(TYPE_EFFECT)) then return false end
	if type&TYPE_MONSTER~=0 then
		return c:GetAttack()>0
	elseif type&TYPE_SPELL~=0 then
		return aux.NegateMonsterFilter(c) and Duel.GetCurrentPhase()~=PHASE_DAMAGE
	elseif type&TYPE_TRAP~=0 then
		return c:IsAbleToHand() and Duel.GetCurrentPhase()~=PHASE_DAMAGE
	end
	return false
end
function c10793085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10793085.tgfilter(chkc,e:GetLabel()) end
	if chk==0 then return e:IsCostChecked()
		and Duel.IsExistingMatchingCard(c10793085.costfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10793085.costfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local type=g:GetFirst():GetType()
	e:SetLabel(type)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tag=Duel.SelectTarget(tp,c10793085.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,type)
	if type&TYPE_MONSTER~=0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	elseif type&TYPE_SPELL~=0 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tag,1,0,0)
	elseif type&TYPE_TRAP~=0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tag,1,0,0)
	end
end
function c10793085.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local type=e:GetLabel()
	if type==nil then return end
	if tc:IsRelateToEffect(e) then
		if type&TYPE_MONSTER~=0 and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		if type&TYPE_SPELL~=0 and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
		if type&TYPE_TRAP~=0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
