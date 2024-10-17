--ユニゾン・チューン
---@param c Card
function c12743620.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12743620+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12743620.target)
	e1:SetOperation(c12743620.activate)
	c:RegisterEffect(e1)
end
function c12743620.filter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and Duel.IsExistingTarget(c12743620.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv)
end
function c12743620.filter2(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and (not c:IsType(TYPE_TUNER) or not c:IsLevel(lv))
end
function c12743620.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c12743620.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c12743620.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c12743620.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g1:GetFirst():GetLevel())
	if g1:GetFirst():IsControler(tp) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,1-tp,LOCATION_GRAVE)
	end
end
function c12743620.activate(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsRelateToEffect(e) and Duel.Remove(hc,POS_FACEUP,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_REMOVED) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(hc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
	end
end
