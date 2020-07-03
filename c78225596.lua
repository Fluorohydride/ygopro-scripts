--充電機塊セルトパス
function c78225596.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x14b),2,2)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c78225596.imcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78225596,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c78225596.atkcon)
	e3:SetOperation(c78225596.atkop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78225596,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c78225596.drcon)
	e4:SetTarget(c78225596.drtg)
	e4:SetOperation(c78225596.drop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabelObject(e4)
	e5:SetOperation(c78225596.chk)
	c:RegisterEffect(e5)
end
function c78225596.chkfilter(c,tp,g)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x14b) and c:IsType(TYPE_LINK)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not g:IsContains(c)
end
function c78225596.chk(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then
		e:GetLabelObject():SetLabel(0)
	else
		local g=e:GetHandler():GetMutualLinkedGroup()
		if eg:IsExists(c78225596.chkfilter,1,nil,tp,g) then
			e:GetLabelObject():SetLabel(1)
		else
			e:GetLabelObject():SetLabel(0)
		end
	end
end
function c78225596.imcon(e)
	return e:GetHandler():IsLinkState()
end
function c78225596.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMutualLinkedGroup()
	local ac=Duel.GetAttacker()
	local bc=ac:GetBattleTarget()
	if not bc then return false end
	if not ac:IsControler(tp) then ac,bc=bc,ac end
	e:SetLabelObject(ac)
	return ac:IsControler(tp) and ac:IsFaceup() and ac:IsType(TYPE_LINK) and ac:IsSetCard(0x14b) and g:IsContains(ac)
		and ac:IsRelateToBattle() and bc:IsControler(1-tp)
end
function c78225596.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabelObject()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=e:GetHandler():GetMutualLinkedGroup()
	if ac:IsRelateToBattle() and ac:IsFaceup() and ac:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(g:GetCount()*1000)
		ac:RegisterEffect(e1)
	end
end
function c78225596.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=0
end
function c78225596.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78225596.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
