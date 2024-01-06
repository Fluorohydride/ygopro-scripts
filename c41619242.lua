--肆世壊からの天跨
function c41619242.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,41619242+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c41619242.target)
	e1:SetOperation(c41619242.activate)
	c:RegisterEffect(e1)
end
function c41619242.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x17a) or c:IsCode(56099748))
end
function c41619242.atkfilter2(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c41619242.disfilter(c,tp)
	return (c:IsSetCard(0x17a) or c:IsCode(56099748))
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
end
function c41619242.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ct=Duel.GetReadyChain()
	local b1=Duel.IsExistingTarget(c41619242.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c41619242.atkfilter2,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then
		local te,tg
		if ct>0 then
			te,tg=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		end
		return b1 or (Duel.GetCurrentPhase()~=PHASE_DAMAGE
			and te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
			and tg and tg:IsExists(c41619242.disfilter,1,nil,tp) and Duel.IsChainDisablable(ct))
	end
	local te,tg
	local b2=false
	if ct>0 then
		te,tg=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		b2=Duel.GetCurrentPhase()~=PHASE_DAMAGE
			and te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
			and tg and tg:IsExists(c41619242.disfilter,1,nil,tp) and Duel.IsChainDisablable(ct)
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(41619242,0),aux.Stringid(41619242,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(41619242,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(41619242,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=Duel.SelectTarget(tp,c41619242.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectTarget(tp,c41619242.atkfilter2,tp,0,LOCATION_MZONE,1,1,nil)
		g1:Merge(g2)
	else
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,te:GetHandler(),1,0,0)
	end
end
function c41619242.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
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
	else
		Duel.NegateEffect(Duel.GetCurrentChain()-1)
	end
end
