--明星の機械騎士
function c72006609.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c72006609.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72006609,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72006609)
	e1:SetCondition(c72006609.thcon)
	e1:SetCost(c72006609.thcost)
	e1:SetTarget(c72006609.thtg)
	e1:SetOperation(c72006609.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x10c))
	e2:SetValue(c72006609.tglimit)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x10c))
	e3:SetValue(c72006609.tglimit)
	c:RegisterEffect(e3)
end
function c72006609.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x10c)
end
function c72006609.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c72006609.costfilter(c)
	return ((c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xfe)) and c:IsDiscardable()
end
function c72006609.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72006609.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c72006609.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c72006609.thfilter(c)
	return c:IsSetCard(0xfe) and c:IsAbleToHand()
end
function c72006609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72006609.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72006609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72006609.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c72006609.tglimit(e,c)
	return not c:GetBattleTarget():GetColumnGroup():IsContains(c)
end
