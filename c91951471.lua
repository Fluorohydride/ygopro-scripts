--VS 螺旋流辻風
function c91951471.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,91951471+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetTarget(c91951471.target)
	e1:SetOperation(c91951471.activate)
	c:RegisterEffect(e1)
end
function c91951471.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x195) and c:IsCanChangePosition()
end
function c91951471.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c91951471.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c91951471.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c91951471.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c91951471.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x195)
end
function c91951471.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c91951471.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsLocation(LOCATION_MZONE)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
		local g=Duel.GetMatchingGroup(c91951471.filter2,tp,LOCATION_MZONE,0,nil)
		local num=g:GetClassCount(Card.GetCode)
		local g2=Duel.GetMatchingGroup(c91951471.filter3,tp,0,LOCATION_MZONE,nil)
		if #g>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(91951471,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=g2:Select(tp,1,num,nil)
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		end
	end
end
