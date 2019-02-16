--ソウル・オブ・スタチュー
function c49514333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c49514333.target)
	e1:SetOperation(c49514333.activate)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
end
function c49514333.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,49514333,0,0x21,1000,1800,4,RACE_ROCK,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49514333.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,49514333,0,0x21,1000,1800,4,RACE_ROCK,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c49514333.reptg)
	e1:SetValue(c49514333.repval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(e)
	c:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
end
function c49514333.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE and c:GetLeaveFieldDest()==0 and c:IsReason(REASON_DESTROY)
		and c:GetReasonPlayer()==1-tp and c:GetOwner()==tp and bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsCanTurnSet()
end
function c49514333.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c49514333.repfilter,e:GetHandler(),tp)
		return count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=count
	end
	if Duel.SelectYesNo(tp,aux.Stringid(49514333,0)) then
		local container=e:GetLabelObject():GetLabelObject()
		container:Clear()
		local g=eg:Filter(c49514333.repfilter,e:GetHandler(),tp)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			tc=g:GetNext()
		end
		Duel.ChangePosition(g,POS_FACEDOWN)
		container:Merge(g)
		return true
	end
	return false
end
function c49514333.repval(e,c)
	return e:GetLabelObject():GetLabelObject():IsContains(c)
end
