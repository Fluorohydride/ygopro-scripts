--RR－ファイナル・フォートレス・ファルコン
function c43047672.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43047672.imcon)
	e1:SetValue(c43047672.efilter)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43047672,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c43047672.cost)
	e2:SetTarget(c43047672.target)
	e2:SetOperation(c43047672.operation)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43047672,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(2)
	e3:SetCondition(c43047672.atcon)
	e3:SetCost(c43047672.atcost)
	e3:SetOperation(c43047672.atop)
	c:RegisterEffect(e3)
end
function c43047672.imfilter(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ)
end
function c43047672.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c43047672.imfilter,1,nil)
end
function c43047672.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c43047672.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c43047672.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER)
end
function c43047672.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43047672.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c43047672.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c43047672.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43047672.filter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
function c43047672.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable(0)
end
function c43047672.atfilter(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c43047672.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43047672.atfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43047672.atfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c43047672.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
