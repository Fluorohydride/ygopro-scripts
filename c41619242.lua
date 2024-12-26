--肆世壊からの天跨
---@param c Card
function c41619242.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41619242,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,41619242+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c41619242.atktg)
	e1:SetOperation(c41619242.atkop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41619242,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,41619242+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c41619242.discon)
	e2:SetTarget(c41619242.distg)
	e2:SetOperation(c41619242.disop)
	c:RegisterEffect(e2)
end
function c41619242.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x17a) or c:IsCode(56099748))
end
function c41619242.atkfilter2(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c41619242.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c41619242.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c41619242.atkfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c41619242.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c41619242.atkfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
end
function c41619242.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<2 then return end
	local sc1=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local sc2=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if not sc1 or not sc2 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(math.max(sc2:GetAttack(),sc2:GetDefense()))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc1:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	sc1:RegisterEffect(e2)
end
function c41619242.disfilter(c,tp)
	return (c:IsSetCard(0x17a) or c:IsCode(56099748))
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
end
function c41619242.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c41619242.disfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c41619242.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c41619242.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
