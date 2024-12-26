--エーリアン・スカル
---@param c Card
function c25920413.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(c25920413.spcon)
	e1:SetTarget(c25920413.sptg)
	e1:SetOperation(c25920413.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25920413,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c25920413.ctcon)
	e2:SetOperation(c25920413.ctop)
	c:RegisterEffect(e2)
	--atk def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c25920413.adcon)
	e3:SetTarget(c25920413.adtg)
	e3:SetValue(c25920413.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
c25920413.counter_add_list={0x100e}
function c25920413.spfilter(c,tp)
	return c:IsLevelBelow(3) and c:IsFaceup() and c:IsReleasable(REASON_SPSUMMON)
		and Duel.GetMZoneCount(1-tp,c,tp)
end
function c25920413.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
		and Duel.IsExistingMatchingCard(c25920413.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c25920413.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c25920413.spfilter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c25920413.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c25920413.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c25920413.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		c:AddCounter(0x100e,1)
	end
end
function c25920413.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c25920413.adtg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x100e)~=0 and bc:IsSetCard(0xc)
end
function c25920413.adval(e,c)
	return c:GetCounter(0x100e)*-300
end
