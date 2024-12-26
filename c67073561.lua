--ミス・ケープ・バーバ
---@param c Card
function c67073561.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67073561,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67073561)
	e1:SetTarget(c67073561.rmtg)
	e1:SetOperation(c67073561.rmop)
	c:RegisterEffect(e1)
end
function c67073561.rmfilter(c,g)
	return g:IsContains(c) and c:IsAbleToRemove()
end
function c67073561.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	lg:AddCard(c)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67073561.rmfilter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c67073561.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c67073561.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c67073561.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(67073561,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c67073561.retcon)
		e1:SetOperation(c67073561.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67073561.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(67073561)~=0
end
function c67073561.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
