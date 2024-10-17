--レッド・スプレマシー
---@param c Card
function c50584941.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50584941.cost)
	e1:SetTarget(c50584941.target)
	e1:SetOperation(c50584941.activate)
	c:RegisterEffect(e1)
end
function c50584941.cfilter(c,tp)
	local code=c:GetOriginalCode()
	return c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c50584941.filter,tp,LOCATION_MZONE,0,1,nil,code)
end
function c50584941.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(c50584941.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) then
			e:SetLabel(1)
			return true
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c50584941.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
	e:SetLabelObject(g:GetFirst())
end
function c50584941.filter(c,code)
	return c:IsFaceup() and c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(code)
end
function c50584941.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50584941.filter(chkc,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		e:SetLabelObject(nil)
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c50584941.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabel())
end
function c50584941.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=e:GetLabel()
	local name=e:GetLabelObject():GetOriginalCodeRule()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(name)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:ReplaceEffect(code,RESET_EVENT+RESETS_STANDARD)
	end
end
