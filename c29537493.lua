--ベアルクティ－ミクポーラ
function c29537493.initial_effect(c)
	--special summon
	local e1=aux.AddUrsarcticSpSummonEffect(c)
	e1:SetDescription(aux.Stringid(29537493,0))
	e1:SetCountLimit(1,29537493)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29537493,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,29537494)
	e2:SetTarget(c29537493.thtg)
	e2:SetOperation(c29537493.thop)
	c:RegisterEffect(e2)
end
function c29537493.thfilter(c)
	return c:IsSetCard(0x163) and c:IsType(TYPE_MONSTER) and not c:IsCode(29537493) and c:IsAbleToHand()
end
function c29537493.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29537493.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29537493.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29537493.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
