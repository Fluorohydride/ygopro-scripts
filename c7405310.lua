--エクストラゲート
---@param c Card
function c7405310.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7405310.target)
	e1:SetOperation(c7405310.operation)
	c:RegisterEffect(e1)
end
function c7405310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp)
	e:SetLabel(lv)
end
function c7405310.filter(c,lv)
	return c:IsLevel(lv)
end
function c7405310.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(tp) then return end
	local g=Duel.GetMatchingGroup(c7405310.filter,1-tp,LOCATION_EXTRA,0,nil,e:GetLabel())
	if g:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local rg=g:FilterSelect(1-tp,Card.IsAbleToRemove,1,1,nil)
		if rg:GetCount()~=0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	else
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
