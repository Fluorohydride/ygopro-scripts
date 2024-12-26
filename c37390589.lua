--鎖付きブーメラン
---@param c Card
function c37390589.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c37390589.target)
	e1:SetOperation(c37390589.operation)
	c:RegisterEffect(e1)
end
function c37390589.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return false
		elseif e:GetLabel()==1 then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()
		else return false end
	end
	local b1=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetTurnPlayer()~=tp
		and Duel.GetAttacker():IsLocation(LOCATION_MZONE) and Duel.GetAttacker():IsAttackPos()
		and Duel.GetAttacker():IsCanChangePosition() and Duel.GetAttacker():IsCanBeEffectTarget(e)
	local b2=e:IsCostChecked()
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(37390589,0),aux.Stringid(37390589,1),aux.Stringid(37390589,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(37390589,0))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(37390589,1))+1
	end
	if opt==0 or opt==2 then
		Duel.SetTargetCard(Duel.GetAttacker())
	end
	if opt==1 or opt==2 then
		if e:IsCostChecked() then
			local c=e:GetHandler()
			local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMAIN_FIELD)
			e1:SetProperty(EFFECT_FLAG_OATH)
			e1:SetReset(RESET_CHAIN)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_DISABLED)
			e2:SetOperation(c37390589.tgop)
			e2:SetLabel(cid)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	end
	e:SetLabel(opt)
end
function c37390589.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function c37390589.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	if opt==0 or opt==2 then
		local tc=Duel.GetAttacker()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
	if opt==1 or opt==2 then
		if not c:IsLocation(LOCATION_SZONE) then return end
		if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
		local tc=e:GetLabelObject()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
			Duel.Equip(tp,c,tc)
			--Atkup
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_EQUIP)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			--Equip limit
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EQUIP_LIMIT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(c37390589.eqlimit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		else
			c:CancelToGrave(false)
		end
	end
end
function c37390589.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c or c:IsControler(e:GetHandlerPlayer())
end
