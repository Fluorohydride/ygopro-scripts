--フェイバリット・ヒーロー
function c11881272.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c11881272.target)
	e1:SetOperation(c11881272.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c11881272.eqlimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c11881272.atkval)
	e3:SetCondition(c11881272.atkcon)
	c:RegisterEffect(e3)
	--effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	e4:SetCondition(c11881272.atkcon)
	c:RegisterEffect(e4)
	--activate field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11881272,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,11881272)
	e5:SetTarget(c11881272.acttg)
	e5:SetOperation(c11881272.actop)
	c:RegisterEffect(e5)
	--chain atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11881272,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c11881272.chacon)
	e6:SetCost(c11881272.chacost)
	e6:SetOperation(c11881272.chaop)
	c:RegisterEffect(e6)
end
function c11881272.eqfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsSetCard(0x8)
end
function c11881272.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11881272.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11881272.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c11881272.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c11881272.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c11881272.eqfilter(tc) then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c11881272.eqlimit(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x8)
end
function c11881272.atkval(e,c)
	return e:GetHandler():GetEquipTarget():GetBaseDefense()
end
function c11881272.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function c11881272.actfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c11881272.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11881272.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c11881272.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11881272,2))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,11881272,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,c11881272.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,11881272)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,11881272,RESET_CHAIN,0,1) end
		local b=te:IsActivatable(tp,true,true)
		if b then
			Duel.ResetFlagEffect(tp,11881272)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c11881272.chacon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==ec and ec:IsRelateToBattle() and ec:IsStatus(STATUS_OPPO_BATTLE) and ec:IsChainAttackable()
end
function c11881272.chacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11881272.chaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
