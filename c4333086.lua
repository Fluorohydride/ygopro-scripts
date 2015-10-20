--Shiranui Style: Sword of Swallow
function c4333086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4333086)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c4333086.cost)
	e1:SetTarget(c4333086.target)
	e1:SetOperation(c4333086.activate)
	c:RegisterEffect(e1)
end
function c4333086.filter(c)
	return c:IsSetCard(0xd7) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c4333086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_ZOMBIE) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_ZOMBIE)
	Duel.Release(g,REASON_COST)
end
function c4333086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) 
	and Duel.IsExistingMatchingCard(c4333086.filter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c4333086.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	local g2=Duel.SelectMatchingCard(tp,c4333086.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g2:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
