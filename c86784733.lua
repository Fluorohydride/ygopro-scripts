--サイバース・シンクロン
function c86784733.initial_effect(c)
	--Increase level
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_UPDATE_LEVEL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c86784733.target)
	e1:SetOperation(c86784733.operation)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,86784733)
	e2:SetTarget(c86784733.reptg)
	e2:SetValue(c86784733.repval)
	c:RegisterEffect(e2)
end
function c86784733.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(4)
end
function c86784733.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c86784733.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86784733.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c86784733.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c86784733.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(tc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c86784733.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5 and c:IsControler(tp)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c86784733.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c86784733.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c86784733.repval(e,c)
	return c86784733.repfilter(c,e:GetHandlerPlayer())
end
