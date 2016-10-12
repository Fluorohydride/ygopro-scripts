--十二獣ブルホーン
function c85115440.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c85115440.ovfilter,aux.Stringid(85115440,0),2,c85115440.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c85115440.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c85115440.defval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85115440,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c85115440.cost)
	e3:SetTarget(c85115440.target)
	e3:SetOperation(c85115440.operation)
	c:RegisterEffect(e3)
end
function c85115440.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(85115440)
end
function c85115440.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,85115440)==0 end
	Duel.RegisterFlagEffect(tp,85115440,RESET_PHASE+PHASE_END,0,1)
end
function c85115440.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c85115440.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c85115440.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c85115440.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c85115440.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c85115440.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c85115440.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85115440.filter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c85115440.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85115440.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c85115440.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c85115440.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
