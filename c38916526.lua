--空牙団の英雄 ラファール
function c38916526.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38916526,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,38916526)
	e1:SetTarget(c38916526.thtg)
	e1:SetOperation(c38916526.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38916526,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38916527)
	e2:SetCondition(c38916526.negcon)
	e2:SetCost(c38916526.negcost)
	e2:SetTarget(c38916526.negtg)
	e2:SetOperation(c38916526.negop)
	c:RegisterEffect(e2)
end
function c38916526.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x114) and not c:IsCode(38916526)
end
function c38916526.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroup(c38916526.ctfilter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c38916526.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(c38916526.ctfilter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		local tg=g:Filter(Card.IsAbleToHand,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c38916526.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c38916526.cfilter(c)
	return c:IsSetCard(0x114) and c:IsDiscardable()
end
function c38916526.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38916526.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c38916526.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c38916526.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c38916526.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
