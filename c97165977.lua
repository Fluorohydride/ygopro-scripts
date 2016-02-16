--月光舞豹姫
function c97165977.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,51777272,aux.FilterBoolFunction(Card.IsFusionSetCard,0xdf),1,false,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c97165977.splimit)
	c:RegisterEffect(e0)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c97165977.tgvalue)
	c:RegisterEffect(e1)
	--Multiple attacks
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97165977,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c97165977.condition)
	e3:SetOperation(c97165977.operation)
	c:RegisterEffect(e3)
	--ATK Up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97165977,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetOperation(c97165977.atkop)
	c:RegisterEffect(e4)
end
function c97165977.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c97165977.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c97165977.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c97165977.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c97165977.reptg)
	e1:SetValue(c97165977.repval)
	Duel.RegisterEffect(e1,tp)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(2)
		c:RegisterEffect(e2)
	end
end
function c97165977.repfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE) and c:GetFlagEffect(97165977)==0 and not c:IsImmuneToEffect(e)
end
function c97165977.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c97165977.repfilter,1,nil,e,tp) end
	local g=eg:Filter(c97165977.repfilter,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(97165977,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c97165977.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c97165977.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end
