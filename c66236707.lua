--械刀婪魔皇断
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsMainPhase()
		and not Duel.CheckPhaseActivity()
end
function s.cfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.tgfilter(chkc) end
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_HAND,0,e:GetHandler(),tp)+math.floor(Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_EXTRA,0,nil,tp)/6)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function s.getct(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)+g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)/6
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,tp)
		local ct=s.getct(tg)
		if ct>=g:GetCount() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=s.selgroup(tg,tp,g:GetCount())
			if sg:GetCount()>0 and Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT) then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end
function s.selgroup_count(c)
	if c:IsLocation(LOCATION_HAND) then
		return 6
	else
		return 1
	end
end
function s.selgroup(g,tp,ct)
	return g:SelectWithSumEqual(tp,s.selgroup_count,ct*6,1,#g)
end
