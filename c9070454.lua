--龍皇の波動
---@param c Card
function c9070454.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9070454+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9070454.condition)
	e1:SetTarget(c9070454.target)
	e1:SetOperation(c9070454.activate)
	c:RegisterEffect(e1)
end
function c9070454.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c9070454.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9070454.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9070454.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c9070454.filter,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and rc:IsType(TYPE_MONSTER) and rc:IsLocation(LOCATION_GRAVE) and aux.NecroValleyFilter()(rc)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(9070454,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetCount()>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_REMOVED) then
				Duel.SpecialSummonStep(rc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(RESET_TURN_SET)
				rc:RegisterEffect(e2)
				Duel.SpecialSummonComplete()
			end
		end
	end
end
