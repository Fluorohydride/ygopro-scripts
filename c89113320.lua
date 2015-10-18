--Performapal Big Bite Turtle
function c89113320.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83982270,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c89113320.condition)
	e2:SetTarget(c89113320.target)
	e2:SetOperation(c89113320.operation)
	c:RegisterEffect(e2)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84171830,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c89113320.lvtg)
	e3:SetOperation(c89113320.lvop)
	c:RegisterEffect(e3)
end
function c89113320.filter(c)
	return c:IsSetCard(0x9f) or c:IsSetCard(0x99) and c:IsType(TYPE_MONSTER)
end
function c89113320.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c89113320.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c89113320.afilter(c,code)
	return c:IsCode(code)
end
function c89113320.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c89113320.filter,tp,LOCATION_HAND,0,1,1,nil)
	local hg=Duel.GetMatchingGroup(c89113320.afilter,tp,LOCATION_HAND,0,nil,tc:GetFirst():GetCode())
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end

function c89113320.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
end
function c89113320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c89113320.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsFaceup() and bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)~=0 then
	end
end
