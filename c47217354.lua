--魔轟神レイヴン
function c47217354.initial_effect(c)
	--lv atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47217354,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c47217354.tg)
	e1:SetOperation(c47217354.op)
	c:RegisterEffect(e1)
end
function c47217354.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local min,max=Duel.GetDiscardHandChangeCount(tp,REASON_EFFECT,1,60)
		return max>0 and Duel.CheckDiscardHand(tp,nil,1,REASON_DISCARD+REASON_EFFECT)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c47217354.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local min,max=Duel.GetDiscardHandChangeCount(tp,REASON_EFFECT,1,60)
	if max<=0 then return end
	if min<=0 then min=1 end
	if Duel.DiscardHand(tp,nil,min,max,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local ct=Duel.GetOperatedGroup():GetCount()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*400)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e2:SetValue(ct)
		c:RegisterEffect(e2)
	end
end
