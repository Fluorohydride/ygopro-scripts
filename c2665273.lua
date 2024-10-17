--永の王 オルムガンド
---@param c Card
function c2665273.initial_effect(c)
	c:SetUniqueOnField(1,0,2665273)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--base atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c2665273.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2665273,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,2665273)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(c2665273.drcost)
	e3:SetTarget(c2665273.drtg)
	e3:SetOperation(c2665273.drop)
	c:RegisterEffect(e3)
end
function c2665273.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c2665273.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c2665273.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c2665273.matfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c2665273.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local td=Duel.Draw(tp,1,REASON_EFFECT)
	local ed=Duel.Draw(1-tp,1,REASON_EFFECT)
	if td+ed>0 and c:IsRelateToEffect(e) then
		local sg=Group.CreateGroup()
		local tg1=Duel.GetMatchingGroup(c2665273.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e),e)
		if td>0 and tg1:GetCount()>0 then
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc1=tg1:Select(tp,1,1,nil):GetFirst()
			if tc1 then
				tc1:CancelToGrave()
				sg:AddCard(tc1)
			end
		end
		local tg2=Duel.GetMatchingGroup(c2665273.matfilter,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e),e)
		if ed>0 and tg2:GetCount()>0 then
			Duel.ShuffleHand(1-tp)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
			local tc2=tg2:Select(1-tp,1,1,nil):GetFirst()
			if tc2 then
				tc2:CancelToGrave()
				sg:AddCard(tc2)
			end
		end
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			for tc in aux.Next(sg) do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
			end
			Duel.Overlay(c,sg)
		end
	end
end
