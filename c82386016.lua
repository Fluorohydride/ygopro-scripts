--烏合の行進
function c82386016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c82386016.cost)
	e1:SetTarget(c82386016.target)
	e1:SetOperation(c82386016.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(82386016,ACTIVITY_CHAIN,c82386016.chainfilter)
end
function c82386016.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c82386016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(82386016,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c82386016.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82386016.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c82386016.drct(tp)
	local ct=0
	if Duel.IsExistingMatchingCard(c82386016.filter,tp,LOCATION_MZONE,0,1,nil,RACE_BEAST) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c82386016.filter,tp,LOCATION_MZONE,0,1,nil,RACE_BEASTWARRIOR) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c82386016.filter,tp,LOCATION_MZONE,0,1,nil,RACE_WINDBEAST) then ct=ct+1 end
	return ct
end
function c82386016.filter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c82386016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c82386016.drct(tp)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c82386016.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=c82386016.drct(tp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,ct,REASON_EFFECT)
end
