--共振装置
---@param c Card
function c26864586.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26864586.target)
	e1:SetOperation(c26864586.activate)
	c:RegisterEffect(e1)
end
function c26864586.filter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and Duel.IsExistingTarget(c26864586.filter2,tp,LOCATION_MZONE,0,1,c,c:GetRace(),c:GetAttribute(),lv)
end
function c26864586.filter2(c,rc,at,lv)
	return not c:IsLevel(lv) and c:IsLevelAbove(1) and c:IsFaceup() and c:IsRace(rc) and c:IsAttribute(at)
end
function c26864586.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c26864586.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c26864586.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	e:SetLabelObject(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26864586,0))
	local g2=Duel.SelectTarget(tp,c26864586.filter2,tp,LOCATION_MZONE,0,1,1,tc1,tc1:GetRace(),tc1:GetAttribute(),tc1:GetLevel())
end
function c26864586.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=e:GetLabelObject()
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	local lv=tc1:GetLevel()
	if tc2:IsLevel(lv) then return end
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
	end
end
