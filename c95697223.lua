--竜の闘志
function c95697223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95697223.target)
	e1:SetOperation(c95697223.activate)
	c:RegisterEffect(e1)
end
function c95697223.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c95697223.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c95697223.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95697223.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(Card.IsStatus,tp,0,LOCATION_MZONE,nil,STATUS_SPSUMMON_TURN)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c95697223.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c95697223.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(Card.IsStatus,tp,0,LOCATION_MZONE,nil,STATUS_SPSUMMON_TURN)
	if ct>0 and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
