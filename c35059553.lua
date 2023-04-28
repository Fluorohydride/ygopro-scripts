--カイザーコロシアム
function c35059553.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--mzone limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c35059553.value)
	c:RegisterEffect(e2)
	--advance summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(c35059553.sumlimit)
	c:RegisterEffect(e3)
	--workaround for nibiru
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c35059553.nibirucon)
	e4:SetValue(c35059553.nibirulimit)
	c:RegisterEffect(e4)
end
function c35059553.value(e,fp,rp,r)
	if rp==e:GetHandlerPlayer() or r~=LOCATION_REASON_TOFIELD then return 7 end
	local limit=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return limit>0 and limit or 7
end
function c35059553.sumlimit(e,c)
	local tp=e:GetHandlerPlayer()
	if c:IsControler(1-tp) then
		local mint,maxt=c:GetTributeRequirement()
		local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		local y=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local ex=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE)
		local exs=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE_SUM)
		if ex==0 and exs>0 then ex=1 end
		return y-maxt+ex+1 > x-ex
	else
		return false
	end
end
function c35059553.nibirufilter(c)
	return not c:IsReleasableByEffect()
end
function c35059553.nibirucon(e)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then return false end
	local c1=Duel.GetMatchingGroupCount(c35059553.nibirufilter,tp,LOCATION_MZONE,0,nil)
	local c2=Duel.GetMatchingGroupCount(c35059553.nibirufilter,tp,0,LOCATION_MZONE,nil)
	return c1 <= c2
end
function c35059553.nibirulimit(e,re,tp)
	return re:GetHandler():IsOriginalCodeRule(27204311)
end
