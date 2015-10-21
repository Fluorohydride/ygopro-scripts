--不知火流 燕の太刀
function c4333086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4333086+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c4333086.cost)
	e1:SetTarget(c4333086.target)
	e1:SetOperation(c4333086.activate)
	c:RegisterEffect(e1)
end
function c4333086.rfilter(c)
	return c:IsRace(RACE_ZOMBIE) and Duel.IsExistingTarget(Card.IsDestructable,0,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c)
end
function c4333086.filter(c)
	return c:IsSetCard(0xd9) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c4333086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c4333086.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c4333086.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c4333086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil)
		and Duel.IsExistingMatchingCard(c4333086.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c4333086.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c4333086.filter,tp,LOCATION_DECK,0,1,1,nil)
		if rg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
