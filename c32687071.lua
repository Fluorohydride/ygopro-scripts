--アモルファージ・ノーテス
function c32687071.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c32687071.mtcon)
	e1:SetOperation(c32687071.mtop)
	c:RegisterEffect(e1)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e2:SetCondition(c32687071.discon)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c32687071.splimit)
	c:RegisterEffect(e3)
end
function c32687071.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c32687071.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckReleaseGroup(tp,nil,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(32687071,0)) then
		local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
		Duel.Release(sg,REASON_RULE)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c32687071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c32687071.discon(e)
	return Duel.IsExistingMatchingCard(c32687071.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c32687071.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe0) and c:IsLocation(LOCATION_EXTRA)
end
