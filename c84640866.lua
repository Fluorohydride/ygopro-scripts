--電網の落とし穴
function c84640866.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c84640866.target)
	e1:SetOperation(c84640866.activate)
	c:RegisterEffect(e1)
end
function c84640866.filter(c,tp)
	return c:GetSummonPlayer()~=tp and bit.band(c:GetSummonLocation(),LOCATION_DECK+LOCATION_GRAVE)~=0
		and c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsLocation(LOCATION_MZONE)
end
function c84640866.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c84640866.filter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c84640866.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c84640866.filter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
