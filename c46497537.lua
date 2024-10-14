--トン＝トン
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsLevelAbove(c:GetOriginalLevel()+1) or c:IsAttackAbove(c:GetBaseAttack()+1) or c:IsDefenseAbove(c:GetBaseDefense()+1))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.CheckLPCost(tp,100,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local ct=0
		local ba,bd,bl=tc:GetBaseAttack(),tc:GetBaseDefense(),tc:GetOriginalLevel()
		if tc:IsAttackAbove(ba) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(ba)
			tc:RegisterEffect(e1)
			ct=ct+1
		end
		if tc:IsDefenseAbove(bd) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(bd)
			tc:RegisterEffect(e2)
			ct=ct+1
		end
		if tc:IsLevelAbove(bl) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(bl)
			tc:RegisterEffect(e3)
			ct=ct+1
		end
		if ct==0 then return end
		local lp=Duel.GetLP(tp)
		local m=math.min(lp,1000)//100
		local t={}
		for i=1,m do
			t[i]=i*100
		end
		local ac=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.BreakEffect()
		Duel.PayLPCost(tp,ac,true)
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(0)==Duel.GetLP(1)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
