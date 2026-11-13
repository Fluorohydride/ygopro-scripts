--魔獣の昂進
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--re
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.recost)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
end
function s.rmfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.tzfilter(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0))
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(s.tzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==5
	local b2=Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetDecktopGroup(tp,10):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==10
	local b3=Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.GetDecktopGroup(tp,15):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==15
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),5},
			{b2,aux.Stringid(id,2),10},
			{b3,aux.Stringid(id,3),15})
	e:SetLabel(op)
	Duel.DisableShuffleCheck()
	local g=Duel.GetDecktopGroup(tp,op)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local op=e:GetLabel()
	if chkc then
		if op==5 then
			return chkc:IsLocation(LOCATION_MZONE) and s.tzfilter(chkc)
		elseif op==10 then
			return chkc:IsLocation(LOCATION_MZONE) and aux.NegateMonsterFilter(chkc)
		elseif op==15 then
			return chkc:IsLocation(LOCATION_MZONE) and s.rmfilter(chkc,tp)
		end
	end
	if chk==0 then return e:IsCostChecked() end
	if op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,s.tzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
	elseif op==10 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	elseif op==15 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToChain() and tc:IsType(TYPE_MONSTER) then
		if op==5 and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
		elseif op==10 and tc:IsFaceup() then
			if tc:IsCanBeDisabledByEffect(e,true) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		elseif op==15 then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
