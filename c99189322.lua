--アルカナコール
---@param c Card
function c99189322.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99189322.target)
	e1:SetOperation(c99189322.activate)
	c:RegisterEffect(e1)
end
function c99189322.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5) and c:GetFlagEffect(FLAG_ID_REVERSAL_OF_FATE)~=0
end
function c99189322.rfilter(c)
	return c:IsSetCard(0x5) and c:IsAbleToRemove()
end
function c99189322.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c99189322.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c99189322.rfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99189322.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99189322.rfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tc:GetControler(),LOCATION_GRAVE)
	e:SetLabelObject(g:GetFirst())
end
function c99189322.activate(e,tp,eg,ep,ev,re,r,rp)
	local regc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==regc then tc=g:GetNext() end
	if not regc:IsRelateToEffect(e) then return end
	if Duel.Remove(regc,POS_FACEUP,REASON_EFFECT)==0 or not regc:IsLocation(LOCATION_REMOVED) then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetFlagEffect(FLAG_ID_REVERSAL_OF_FATE)~=0 and tc:GetFlagEffect(FLAG_ID_ARCANA_COIN)~=0 then
		local cid=tc:ReplaceEffect(regc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterFlagEffect(99189322,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(cid)
		e1:SetLabelObject(tc)
		e1:SetOperation(c99189322.rec_effect)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c99189322.rec_effect(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(99189322)==0 then return end
	tc:ResetEffect(cid,RESET_COPY)
end
