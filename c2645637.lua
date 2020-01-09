--零氷の魔妖－雪女
function c2645637.initial_effect(c)
	c:SetUniqueOnField(1,0,2645637)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,4)
	--disable effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c2645637.disop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2645637,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,2645637)
	e2:SetCondition(c2645637.atkcon)
	e2:SetTarget(c2645637.atktg)
	e2:SetOperation(c2645637.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c2645637.atkcon2)
	c:RegisterEffect(e3)
end
function c2645637.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_REMOVED and re:IsActiveType(TYPE_MONSTER) and rp==1-tp then
		Duel.NegateEffect(ev)
	end
end
function c2645637.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE
end
function c2645637.spfilter(c)
	return c:GetSummonLocation()==LOCATION_GRAVE
end
function c2645637.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c2645637.spfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c2645637.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c2645637.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c2645637.atkfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c2645637.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local g=Duel.SelectTarget(tp,c2645637.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c2645637.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end
