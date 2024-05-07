--エクシーズ・ブロック
function c44487250.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c44487250.condition)
	e1:SetCost(c44487250.cost)
	e1:SetTarget(c44487250.target)
	e1:SetOperation(c44487250.activate)
	c:RegisterEffect(e1)
end
function c44487250.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c44487250.only_filter(c,onlyc)
	local require_count=c==onlyc and 2 or 1
	return c:CheckRemoveOverlayCard(tp,require_count,REASON_COST)
end
function c44487250.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if c:IsLocation(LOCATION_HAND) then
			local fromhand_effects={c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND)}
			local available_fromhand_effects={}
			for _,te in ipairs(fromhand_effects) do
				local cost=te:GetCost()
				if te:CheckCountLimit(tp) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0,e)) then
					table.insert(available_fromhand_effects,te)
				end
			end
			if #available_fromhand_effects==1 and available_fromhand_effects[1]:GetValue()==85551711 then
				return Duel.IsExistingMatchingCard(c44487250.only_filter,tp,LOCATION_MZONE,0,1,nil,available_fromhand_effects[1]:GetHandler())
			else
				return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
			end
		else
			return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
		end
	end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c44487250.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c44487250.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
