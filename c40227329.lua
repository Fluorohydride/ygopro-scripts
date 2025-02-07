--GO－DDD神零王ゼロゴッド・レイジ
function c40227329.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c40227329.damcon)
	e1:SetValue(c40227329.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40227329,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c40227329.effcost)
	e3:SetTarget(c40227329.efftg)
	e3:SetOperation(c40227329.effop)
	c:RegisterEffect(e3)
	--attack
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c40227329.atkcon)
	e4:SetOperation(c40227329.atkop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--reduce tribute
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(40227329,4))
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1,40227329)
	e7:SetCondition(c40227329.ntcon)
	e7:SetTarget(c40227329.nttg)
	c:RegisterEffect(e7)
end
function c40227329.damcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),40227329)==0
end
function c40227329.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_EFFECT)~=0 and c:GetFlagEffect(40227329)==0 then
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),40227329,RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function c40227329.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c40227329.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0xaf)
end
function c40227329.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c40227329.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local b1=not c:IsHasEffect(EFFECT_DIRECT_ATTACK) and Duel.IsAbleToEnterBP()
		local b2=Duel.GetFlagEffect(tp,40227330)==0
		local b3=Duel.GetFlagEffect(tp,40227331)==0
		return b1 or b2 or b3
	end
end
function c40227329.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=not c:IsHasEffect(EFFECT_DIRECT_ATTACK) and Duel.IsAbleToEnterBP()
	local b2=Duel.GetFlagEffect(tp,40227330)==0
	local b3=Duel.GetFlagEffect(tp,40227331)==0
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(40227329,0)},
		{b2,aux.Stringid(40227329,1)},
		{b3,aux.Stringid(40227329,2)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(c40227329.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,40227330,RESET_PHASE+PHASE_END,0,1)
	elseif op==3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(0,1)
		e3:SetValue(c40227329.aclimit2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(tp,40227331,RESET_PHASE+PHASE_END,0,1)
	end
end
function c40227329.aclimit1(e,re,tp)
	return re:GetActivateLocation()==LOCATION_SZONE
end
function c40227329.aclimit2(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND
end
function c40227329.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<=4000
end
function c40227329.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(1-tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	e1:SetValue(lp)
	c:RegisterEffect(e1)
end
