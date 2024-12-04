--肆世壊の牙掌突
function c79552283.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--able to be DefensePos attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79552283,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c79552283.adatktg)
	e2:SetOperation(c79552283.adatkop)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79552283,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79552283)
	e4:SetCondition(c79552283.discon)
	e4:SetCost(c79552283.discost)
	e4:SetTarget(c79552283.distg)
	e4:SetOperation(c79552283.disop)
	c:RegisterEffect(e4)
end
function c79552283.filter(c,e,tp)
	return (c:IsSetCard(0x17a) or c:IsCode(56099748)) and c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c79552283.adatktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79552283.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetTurnPlayer()==tp and aux.bpcon(e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsExistingTarget(c79552283.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79552283.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c79552283.adatkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	--defense attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(c79552283.adaval)
	tc:RegisterEffect(e1)
end
function c79552283.adaval(e)
	local c=e:GetHandler()
	return c:GetAttack()>c:GetDefense() and 0 or 1
end
function c79552283.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x17a) and c:GetSequence()>=5
end
function c79552283.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c79552283.exfilter,tp,LOCATION_MZONE,0,1,nil) and rp==1-tp
end
function c79552283.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c79552283.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79552283.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
