--雷仙神
function c70493141.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c70493141.hspcon)
	e1:SetOperation(c70493141.hspop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70493141,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c70493141.reccon)
	e2:SetTarget(c70493141.rectg)
	e2:SetOperation(c70493141.recop)
	c:RegisterEffect(e2)
end
function c70493141.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckLPCost(tp,3000)
end
function c70493141.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,3000)
end
function c70493141.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c70493141.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,5000)
end
function c70493141.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
