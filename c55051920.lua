--オルフェゴール・コア
function c55051920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55051920,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c55051920.tgcost)
	e2:SetTarget(c55051920.tgtg)
	e2:SetOperation(c55051920.tgop)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c55051920.reptg)
	e3:SetValue(c55051920.repval)
	e3:SetOperation(c55051920.repop)
	c:RegisterEffect(e3)
end
function c55051920.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c55051920.tgfilter,tp,LOCATION_ONFIELD,0,1,c)
end
function c55051920.tgfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xfe) or c:IsSetCard(0x11b)) and not c:IsCode(55051920)
end
function c55051920.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55051920.costfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c55051920.costfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c55051920.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c55051920.tgfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c55051920.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c55051920.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c55051920.repfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xfe) or c:IsSetCard(0x11b)) and c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c55051920.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c55051920.repfilter,1,e:GetHandler(),tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c55051920.repval(e,c)
	return c55051920.repfilter(c,e:GetHandlerPlayer())
end
function c55051920.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
