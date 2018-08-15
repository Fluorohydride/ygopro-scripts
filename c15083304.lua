--Danger! Zone
function c15083304.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15083304+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c15083304.target)
	e1:SetOperation(c15083304.activate)
	c:RegisterEffect(e1)
end
function c15083304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c15083304.filter(c)
	return not c:IsSetCard(0x11e)
end
function c15083304.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		if g:IsExists(Card.IsSetCard,1,nil,0x11e) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local g1=g:Select(p,1,1,nil)
			if g1:GetFirst():IsSetCard(0x11e) then
				g:RemoveCard(g1:GetFirst())
			else
				g:Remove(c15083304.filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local g2=g:Select(p,1,1,nil)
			g1:Merge(g2)
			Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
		else
			Duel.ConfirmCards(1-p,g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
