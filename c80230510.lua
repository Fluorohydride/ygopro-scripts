--埋葬されし生け贄
function c80230510.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80230510.target)
	e1:SetOperation(c80230510.activate)
	c:RegisterEffect(e1)
end
function c80230510.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,80230510)==0 end
end
function c80230510.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80230510,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c80230510.otcon)
	e1:SetTarget(c80230510.ottg)
	e1:SetOperation(c80230510.otop)
	e1:SetCountLimit(1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,80230510,RESET_PHASE+PHASE_END,0,1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function c80230510.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c80230510.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80230510.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c80230510.rmfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c80230510.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2
end
function c80230510.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c80230510.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c80230510.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp,80230510)
end
