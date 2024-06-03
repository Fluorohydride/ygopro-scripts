--エクソシスター・リタニア
function c197042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,197042+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c197042.condition)
	e1:SetCost(c197042.cost)
	e1:SetTarget(c197042.target)
	e1:SetOperation(c197042.activate)
	c:RegisterEffect(e1)
	if not c197042.global_check then
		c197042.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c197042.checkcon)
		ge1:SetOperation(c197042.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c197042.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_XYZ)
end
function c197042.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsSummonType,nil,SUMMON_TYPE_XYZ)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetSummonPlayer(),197042)==0 then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),197042,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,197042)>0 and Duel.GetFlagEffect(1,197042)>0 then
			break
		end
		tc=g:GetNext()
	end
end
function c197042.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x172)
end
function c197042.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0 and ct==Duel.GetMatchingGroupCount(c197042.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c197042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c197042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectCardFromFieldFirst(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c197042.xyzfilter(c)
	return c:IsSetCard(0x172) and c:IsXyzSummonable(nil)
end
function c197042.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.AdjustAll()
		local b1=Duel.IsExistingMatchingCard(c197042.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
		local b2=Duel.GetFlagEffect(tp,197042)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(197042,0)},
			{b2,aux.Stringid(197042,1)},
			{true,aux.Stringid(197042,2)})
		if op==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c197042.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.XyzSummon(tp,g:GetFirst(),nil)
		elseif op==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
