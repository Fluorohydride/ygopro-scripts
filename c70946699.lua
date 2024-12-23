--炎虎梁山爆
---@param c Card
function c70946699.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c70946699.target)
	e1:SetOperation(c70946699.operation)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70946699,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c70946699.damcon)
	e2:SetTarget(c70946699.damtg)
	e2:SetOperation(c70946699.damop)
	c:RegisterEffect(e2)
end
function c70946699.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local rec=Duel.GetMatchingGroupCount(c70946699.filter,tp,LOCATION_ONFIELD,0,nil)*500
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c70946699.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c70946699.operation(e,tp,eg,ep,ev,re,r,rp)
	local rec=Duel.GetMatchingGroupCount(c70946699.filter,tp,LOCATION_ONFIELD,0,nil)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
function c70946699.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
		and	c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)
end
function c70946699.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(c70946699.filter,tp,LOCATION_GRAVE,0,nil)*500
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c70946699.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.GetMatchingGroupCount(c70946699.filter,tp,LOCATION_GRAVE,0,nil)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,dam,REASON_EFFECT)
end
