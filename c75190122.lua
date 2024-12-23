--黒・爆・裂・破・魔・導
---@param c Card
function c75190122.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c75190122.condition)
	e1:SetTarget(c75190122.target)
	e1:SetOperation(c75190122.activate)
	c:RegisterEffect(e1)
end
function c75190122.cfilter(c,code)
	return c:IsFaceup() and c:IsOriginalCodeRule(code)
end
function c75190122.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75190122.cfilter,tp,LOCATION_MZONE,0,1,nil,46986414)
		and Duel.IsExistingMatchingCard(c75190122.cfilter,tp,LOCATION_MZONE,0,1,nil,38033121)
end
function c75190122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c75190122.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
