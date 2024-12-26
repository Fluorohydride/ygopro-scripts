--アモルファージ・ノーテス
---@param c Card
function c32687071.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c32687071.descon)
	e1:SetOperation(c32687071.desop)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c32687071.sumlimit)
	c:RegisterEffect(e2)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c32687071.limcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e3)
end
function c32687071.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c32687071.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroupEx(tp,nil,1,REASON_MAINTENANCE,false,c) and Duel.SelectYesNo(tp,aux.Stringid(32687071,0)) then
		local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,REASON_MAINTENANCE,false,c)
		Duel.Release(g,REASON_MAINTENANCE)
	else Duel.Destroy(c,REASON_COST) end
end
function c32687071.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
end
function c32687071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c32687071.limcon(e)
	return Duel.IsExistingMatchingCard(c32687071.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
