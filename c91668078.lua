--雪沓の 跡追うひとつ またひとつ
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return not c:IsCode(id)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil,tp,POS_FACEDOWN) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,5,nil,tp,POS_FACEDOWN)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0
			and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)>=7
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,tp,POS_FACEDOWN) then
			Duel.BreakEffect()
			local ct=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,POS_FACEDOWN)
			if ct>5 then ct=5 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,ct,ct,nil,POS_FACEDOWN)
			if rg:GetCount()>0 then
				Duel.HintSelection(rg)
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
