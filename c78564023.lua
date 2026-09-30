--BF－二の太刀のエテジア
function c78564023.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78564023,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c78564023.condition)
	e1:SetCost(c78564023.cost)
	e1:SetTarget(c78564023.target)
	e1:SetOperation(c78564023.operation)
	c:RegisterEffect(e1)
end
function c78564023.bwfilter(c,tp)
	if not c:IsSetCard(0x33) then return false end
	if c:IsRelateToBattle() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() then
		return true
	end
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c78564023.opfilter(c,tp)
	return c:IsRelateToBattle() and c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end
function c78564023.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not d then return false end
	local bw,op
	if a:IsControler(tp) then
		bw,op=a,d
	else
		bw,op=d,a
	end
	return c78564023.bwfilter(bw,tp) and c78564023.opfilter(op,tp)
end
function c78564023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c78564023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c78564023.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
