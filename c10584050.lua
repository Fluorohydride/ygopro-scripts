--スプリガンズ・ブラスト！
function c10584050.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,10584050+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10584050.condition)
	e1:SetTarget(c10584050.target)
	e1:SetOperation(c10584050.activate)
	c:RegisterEffect(e1)
end
function c10584050.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x155)
end
function c10584050.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10584050.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10584050.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459)
end
function c10584050.fdfilter(c,i)
	return c:IsFacedown() and c:GetSequence()==i
end
function c10584050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local fdzone=0
	for i=0,4 do
		if Duel.IsExistingMatchingCard(c10584050.fdfilter,tp,0,LOCATION_MZONE,1,nil,i) then
			fdzone=fdzone|1<<i
		end
	end
	if chk==0 then return ~fdzone&0x1f>0 end
	local dis=Duel.SelectField(tp,1,0,LOCATION_MZONE,(fdzone|0x60)<<16)
	if Duel.IsExistingMatchingCard(c10584050.cfilter,tp,LOCATION_MZONE,0,1,nil) and ~(fdzone|(dis>>16))&0x1f>0
		and Duel.SelectYesNo(tp,aux.Stringid(10584050,0)) then
		dis=dis|Duel.SelectField(tp,1,0,LOCATION_MZONE,(fdzone|(dis>>16)|0x60)<<16)
	end
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c10584050.disfilter2(c,dis)
	return c:IsFaceup() and (2^c:GetSequence())*0x10000&dis~=0
end
function c10584050.disfilter3(c,dis)
	return c:IsFacedown() and (2^c:GetSequence())*0x10000&dis~=0
end
function c10584050.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dis=e:GetLabel()
	local g=Duel.GetMatchingGroup(c10584050.disfilter2,tp,0,LOCATION_MZONE,nil,dis)
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
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
		dis=dis-(2^tc:GetSequence())*0x10000
		tc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c10584050.disfilter3,tp,0,LOCATION_MZONE,nil,dis)
	local sc=sg:GetFirst()
	while sc do
		dis=dis-(2^sc:GetSequence())*0x10000
		sc=sg:GetNext()
	end
	if dis~=0 then
		if tp==1 then
			dis=((dis&0xffff)<<16)|((dis>>16)&0xffff)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_FIELD)
		e3:SetValue(dis)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
