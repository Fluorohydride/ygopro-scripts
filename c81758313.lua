--一日万倍龍
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x78)
	--counter (end phase)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.ctcost)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--counter (main phase)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.cttg2)
	e2:SetOperation(s.ctop2)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetValue(10000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.reptg)
	e5:SetOperation(s.repop)
	c:RegisterEffect(e5)
end
s.mentioned_counter={
	[0x78]=true,
}
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	Duel.PayLPCost(tp,100)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x78,1) end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		c:AddCounter(0x78,1)
	end
end
function s.cttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	local ct=math.floor(lp/1000)
	if chk==0 then return ct>0 and e:GetHandler():IsCanAddCounter(0x78,ct) end
end
function s.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	local ct=math.floor(lp/1000)
	if c:IsRelateToChain() and c:IsFaceup() and ct>0 then
		c:AddCounter(0x78,ct)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x78)>=10
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0x78,1,REASON_EFFECT)
	end
	return true
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x78,1,REASON_EFFECT)
end
