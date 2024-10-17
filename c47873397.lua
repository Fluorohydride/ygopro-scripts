--トーテムポール
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableCounterPermit(0x68)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--untarget
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(s.intg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--negate attack+counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.ncon)
	e3:SetTarget(s.ntg)
	e3:SetOperation(s.nop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetCondition(s.sdcon)
	c:RegisterEffect(e4)
	--inflict double damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	e5:SetCondition(s.ddcon)
	e5:SetOperation(s.ddop)
	c:RegisterEffect(e5)
end
function s.intg(e,c)
	return c:IsFaceup() and c:GetBaseAttack()==0 and c:IsRace(RACE_ROCK)
end
function s.ncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x68,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x68)
end
function s.nop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x68,1)
	end
end
function s.sdcon(e)
	return e:GetHandler():GetCounter(0x68)==3
end
function s.ddfilter(c)
	return c:IsAttack(0) and c:IsRace(RACE_ROCK)
end
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.ddfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	--becomes doubled
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.damval(e,re,val,r,rp,rc)
	if r&REASON_EFFECT==REASON_EFFECT then
		return val*2
	else return val end
end
