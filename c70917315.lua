--アモルファージ・ルクス
function c70917315.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c70917315.mtcon)
	e1:SetOperation(c70917315.mtop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(c70917315.aclimit)
	e2:SetCondition(c70917315.actcon)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FLIP)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c70917315.filpop)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c70917315.spdamcon)
	e4:SetTarget(c70917315.splimit)
	c:RegisterEffect(e4)
end
function c70917315.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c70917315.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckReleaseGroup(tp,nil,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(70917315,0)) then
		local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
		Duel.Release(sg,REASON_RULE)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c70917315.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c70917315.actcon(e)
	return Duel.IsExistingMatchingCard(c70917315.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c70917315.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsSetCard(0xe0) and not re:GetHandler():IsImmuneToEffect(e)
end
function c70917315.filpop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(70917315,RESET_EVENT+0x1fe0000,0,1)
end
function c70917315.spdamcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM or e:GetHandler():GetFlagEffect(70917315)~=0
end
function c70917315.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe0) and c:IsLocation(LOCATION_EXTRA)
end
