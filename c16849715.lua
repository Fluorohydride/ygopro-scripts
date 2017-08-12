--雷の天気模様
--Prototype, might require a core update for full functionality
function c16849715.initial_effect(c)
	c:SetUniqueOnField(1,0,16849715)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c16849715.effop)
	c:RegisterEffect(e2)
end
function c16849715.efffilter(c,g,ignore_flag)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109)
		and c:GetSequence()<5 and g:IsContains(c) and (ignore_flag or c:GetFlagEffect(16849715)==0)
end
function c16849715.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup(1,1)
	local g=Duel.GetMatchingGroup(c16849715.efffilter,tp,LOCATION_MZONE,0,nil,cg)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(16849715,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(16849715,0))
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetLabelObject(c)
		e1:SetCost(aux.bfgcost)
		e1:SetTarget(c16849715.thtg)
		e1:SetOperation(c16849715.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c16849715.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c16849715.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gc=e:GetLabelObject()
	if chk==0 then return gc and gc:IsFaceup() and gc:IsLocation(LOCATION_SZONE)
		and not gc:IsDisabled() and c16849715.efffilter(c,gc:GetColumnGroup(1,1),true)
		and (Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil)) end
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c16849715.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
