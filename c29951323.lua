--放電ムスタンガン
function c29951323.initial_effect(c)
	c:EnableUnsummonable()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c29951323.splimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(2)
	e2:SetValue(c29951323.valcon)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c29951323.limittg)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c29951323.countcon1)
	e4:SetValue(c29951323.countval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCondition(c29951323.countcon2)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
	if not c29951323.global_check then
		c29951323.global_check=true
		c29951323[0]=0
		c29951323[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c29951323.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c29951323.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c29951323.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c29951323.checkop1(e,tp,eg,ep,ev,re,r,rp)
	c29951323[ep]=c29951323[ep]+1
end
function c29951323.checkop2(e,tp,eg,ep,ev,re,r,rp)
	c29951323[ep]=c29951323[ep]-1
end
function c29951323.clear(e,tp,eg,ep,ev,re,r,rp)
	c29951323[0]=0
	c29951323[1]=0
end
function c29951323.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and Duel.GetActivityCount(e:GetHandlerPlayer(),ACTIVITY_SPSUMMON)==0
		and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c29951323.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c29951323.limittg(e,c,tp)
	if Duel.GetTurnPlayer()~=tp then return false end
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)>=c29951323[tp]
end
function c29951323.countcon1(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c29951323.countcon2(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c29951323.countval(e,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	local t2=c29951323[tp]
	if t1>=t2 then return 0 else return t2-t1 end
end
