--Evil★Twin イージーゲーム
function c34365442.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34365442,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,34365442)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c34365442.cost1)
	e1:SetTarget(c34365442.target1)
	e1:SetOperation(c34365442.activate1)
	c:RegisterEffect(e1)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34365442,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,34365442)
	e3:SetCondition(c34365442.condition2)
	e3:SetCost(c34365442.cost2)
	e3:SetTarget(c34365442.target2)
	e3:SetOperation(c34365442.activate2)
	c:RegisterEffect(e3)
end
function c34365442.tgfilter1(c)
	return c:IsSetCard(0x152,0x153)	and c:IsFaceup()
end
function c34365442.cfilter1(c,tp)
	return c:IsSetCard(0x152,0x153) and c:GetBaseAttack()>0
		and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingTarget(c34365442.tgfilter1,tp,LOCATION_MZONE,0,1,c)
end
function c34365442.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c34365442.cfilter1,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c34365442.cfilter1,1,1,nil,tp)
	e:SetLabel(sg:GetFirst():GetBaseAttack())
	Duel.Release(sg,REASON_COST)
end
function c34365442.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c34365442.tgfilter1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c34365442.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c34365442.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c34365442.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c34365442.cfilter2(c,tp)
	return c:IsSetCard(0x152,0x153)
		and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c34365442.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c34365442.cfilter2,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c34365442.cfilter2,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c34365442.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c34365442.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
