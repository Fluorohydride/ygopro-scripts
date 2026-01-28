--決戦の火蓋
function c39712330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39712330,0))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c39712330.condition)
	e2:SetCost(c39712330.cost)
	e2:SetTarget(c39712330.target)
	e2:SetOperation(c39712330.activate)
	c:RegisterEffect(e2)
end
function c39712330.condition(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c39712330.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c39712330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39712330.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c39712330.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c39712330.filter(c)
	return c:IsType(TYPE_NORMAL) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function c39712330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct1=Duel.GetMatchingGroupCount(c39712330.filter,tp,LOCATION_HAND,0,nil)
		local ct2=Duel.GetFlagEffect(tp,39712330)
		return ct1-ct2>0
	end
	Duel.RegisterFlagEffect(tp,39712330,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c39712330.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c39712330.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
