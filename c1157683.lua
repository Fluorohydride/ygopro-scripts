--サイバーダーク・インヴェイジョン
function c1157683.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1157683,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c1157683.eqtg)
	e1:SetOperation(c1157683.eqop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1157683,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c1157683.descost)
	e2:SetTarget(c1157683.destg)
	e2:SetOperation(c1157683.desop)
	c:RegisterEffect(e2)
end
function c1157683.eqfilter(c,tp)
	return c:IsSetCard(0x4093) and c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and Duel.IsExistingMatchingCard(c1157683.eqfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function c1157683.eqfilter2(c)
	return c:IsRace(RACE_DRAGON+RACE_MACHINE) and not c:IsForbidden()
end
function c1157683.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1157683.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetFlagEffect(tp,1157683)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c1157683.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RegisterFlagEffect(tp,1157683,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1157683.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c1157683.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c1157683.eqfilter2),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		local ec=g:GetFirst()
		if not ec or not Duel.Equip(tp,ec,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c1157683.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
	end
end
function c1157683.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c1157683.cfilter(c)
	return c:IsFaceup() and c:GetEquipTarget() and c:GetEquipTarget():IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c1157683.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1157683.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1157683.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c1157683.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,1157684)==0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RegisterFlagEffect(tp,1157684,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1157683.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
