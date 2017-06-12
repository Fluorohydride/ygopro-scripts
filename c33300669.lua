--アモルファージ・キャヴム
function c33300669.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c33300669.flipop)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c33300669.descon)
	e2:SetOperation(c33300669.desop)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c33300669.sumlimit)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetOperation(c33300669.chainop)
	c:RegisterEffect(e4)
end
function c33300669.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(33300669,RESET_EVENT+0x1fe0000,0,1)
end
function c33300669.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c33300669.chainop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33300669.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) then return false end
	Duel.SetChainLimit(aux.FALSE)
end
function c33300669.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33300669.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(33300669,0)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
function c33300669.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
		and (e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) or e:GetHandler():GetFlagEffect(33300669)~=0)
end
