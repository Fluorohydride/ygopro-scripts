--トリシューラの鼓動
---@param c Card
function c6075533.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,6075533)
	e1:SetTarget(c6075533.target)
	e1:SetOperation(c6075533.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,6075534)
	e2:SetCondition(c6075533.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c6075533.disop)
	c:RegisterEffect(e2)
end
function c6075533.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f) and c:IsType(TYPE_SYNCHRO)
end
function c6075533.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c6075533.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		or ct>=2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		or ct>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	local rct=0
	local loc=0
	if ct>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then
		rct=rct+1
		loc=loc+LOCATION_ONFIELD
	end
	if ct>=2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) then
		rct=rct+1
		loc=loc+LOCATION_GRAVE
	end
	if ct>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) then
		rct=rct+1
		loc=loc+LOCATION_HAND
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,rct,0,loc)
end
function c6075533.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6075533.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local rflag=false
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			rflag=true
		end
	end
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			if rflag then Duel.BreakEffect() end
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			rflag=true
		end
	end
	if ct>2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			if rflag then Duel.BreakEffect() end
			local sg=g:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c6075533.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x2f) and c:IsType(TYPE_SYNCHRO)
end
function c6075533.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c6075533.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c6075533.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
