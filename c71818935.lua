--閉ザサレシ天ノ月
--Coded by Lee
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,2)
	--etxra link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.lmtg)
	e1:SetOperation(s.lmop)
	c:RegisterEffect(e1)
end
function s.filter(c,lg)
	return c:IsFaceup() and lg:IsContains(c) and c:IsCanBeEffectTarget()
end
function s.lmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and s.filter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,lg)
end
function s.lmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then 
		if not tc:IsImmuneToEffect(e) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(c)
		e1:SetCondition(s.mcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(s.matval)
		tc:RegisterEffect(e1)
	end 
end
function s.mcon(e)
	local tp=e:GetOwner():GetControler()
	return e:GetHandler():IsControler(1-tp)
end
function s.matval(e,lc,mg,c,tp)
	local ct=e:GetLabelObject()
	if not lc:IsLink(5) then return false,nil end
	return true,not mg or mg:IsContains(ct)
end