--ラドレミコード・エンジェリア
function c27993919.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c27993919.actcon1)
	e1:SetOperation(c27993919.actop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c27993919.subop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27993919,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,27993919)
	e3:SetTarget(c27993919.sptg)
	e3:SetOperation(c27993919.spop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c27993919.actcon2)
	e4:SetValue(c27993919.actlimit2)
	c:RegisterEffect(e4)
end
function c27993919.actfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c27993919.actcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27993919.actfilter1,1,nil,tp)
end
function c27993919.actop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c27993919.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		c:RegisterFlagEffect(27993919,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c27993919.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c27993919.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(27993919)
	e:Reset()
end
function c27993919.subop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(27993919)~=0 then
		Duel.SetChainLimitTillChainEnd(c27993919.chlimit)
	end
end
function c27993919.chlimit(e,ep,tp)
	return ep==tp or e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c27993919.cfilter(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
		and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c27993919.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCurrentScale())
end
function c27993919.spfilter(c,e,tp,sc)
	return c:IsSetCard(0x162) and c:IsType(TYPE_MONSTER) and not c:IsCode(27993919)
		and math.abs(c:GetCurrentScale()-sc)==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27993919.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c27993919.cfilter,1,REASON_EFFECT,false,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27993919.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c27993919.cfilter,1,1,REASON_EFFECT,false,nil,e,tp)
	if Duel.Release(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c27993919.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst():GetCurrentScale())
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c27993919.pfilter(c)
	return c:GetCurrentScale()%2~=0
end
function c27993919.actcon2(e)
	local a=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return a and a:IsControler(tp) and a:IsSetCard(0x162)
		and Duel.IsExistingMatchingCard(c27993919.pfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c27993919.actlimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
