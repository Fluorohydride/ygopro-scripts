--アルカナフォースEX－THE DARK RULER
local s,id,o=GetID()
function c69831560.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c69831560.spcon)
	e1:SetTarget(c69831560.sptg)
	e1:SetOperation(c69831560.spop)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--coin
	aux.EnableArcanaCoin(c,EVENT_SPSUMMON_SUCCESS)
	--coin effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(c69831560.macon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetCountLimit(1)
	e4:SetCondition(c69831560.poscon)
	e4:SetOperation(c69831560.posop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetCondition(c69831560.descon1)
	e5:SetOperation(c69831560.desop1)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c69831560.descon2)
	e6:SetOperation(c69831560.desop2)
	c:RegisterEffect(e6)
end
function c69831560.spfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c69831560.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c69831560.spfilter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(aux.mzctcheck,3,3,tp)
end
function c69831560.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c69831560.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c69831560.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c69831560.macon(e)
	return e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==1
end
function c69831560.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==1 and c:GetAttackAnnouncedCount()>=2
end
function c69831560.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	c:RegisterEffect(e1)
end
function c69831560.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==0
end
function c69831560.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
function c69831560.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function c69831560.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Destroy(g,REASON_EFFECT)
	c:ResetFlagEffect(id)
end
