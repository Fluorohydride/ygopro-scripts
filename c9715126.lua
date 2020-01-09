--Boot-Up Order - Gear Force
function c9715126.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c9715126.condition)
	e1:SetTarget(c9715126.target)
	e1:SetOperation(c9715126.activate)
	c:RegisterEffect(e1)
end
function c9715126.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_MACHINE)
end
function c9715126.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0
		and not Duel.IsExistingMatchingCard(c9715126.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9715126.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_ATTACK) end
	local g=Duel.GetMatchingGroupCount(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_ATTACK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9715126.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c9715126.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9715126.filter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,ct,nil,POS_ATTACK)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
