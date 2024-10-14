--Ga－P.U.N.K.クラッシュ・ビート
---@param c Card
function c17691568.initial_effect(c)
	--ACT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17691568,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,17691568)
	e2:SetCondition(c17691568.discon)
	e2:SetTarget(c17691568.distg)
	e2:SetOperation(c17691568.disop)
	c:RegisterEffect(e2)
	--Cannot Break
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17691568,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c17691568.limcon)
	e3:SetOperation(c17691568.limop)
	c:RegisterEffect(e3)
end
function c17691568.acfilter(c,tp)
	return c:IsSetCard(0x171) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c17691568.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp==1-tp and tg and tg:IsExists(c17691568.acfilter,1,nil,tp)
end
function c17691568.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17691568.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c17691568.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x171)
end
function c17691568.limcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE)
		and Duel.GetMatchingGroupCount(c17691568.cfilter,tp,LOCATION_MZONE,0,nil)>0
end
function c17691568.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c17691568.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c17691568.tgval)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(17691568,2))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(c17691568.tgval)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2,true)
		tc=g:GetNext()
	end
end
function c17691568.tgval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
