--投石部隊
function c76075810.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76075810,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c76075810.descost)
	e1:SetTarget(c76075810.destg)
	e1:SetOperation(c76075810.desop)
	c:RegisterEffect(e1)
end
function c76075810.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,c,RACE_WARRIOR) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,c,RACE_WARRIOR)
	Duel.Release(g,REASON_COST)
end
function c76075810.filter(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk)
end
function c76075810.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c76075810.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk) end
	local g=Duel.GetMatchingGroup(c76075810.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c76075810.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local atk=c:GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c76075810.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,atk)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
