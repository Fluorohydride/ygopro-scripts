--輝光竜セイファート
function c15381421.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15381421,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,15381421)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c15381421.thcost)
	e1:SetTarget(c15381421.thtg)
	e1:SetOperation(c15381421.thop)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15381422)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c15381421.thtg2)
	e2:SetOperation(c15381421.thop2)
	c:RegisterEffect(e2)
end
function c15381421.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:GetOriginalLevel()>0 and c:IsAbleToGraveAsCost()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c15381421.filter(c,e,tp)
	local rg=Duel.GetMatchingGroup(c15381421.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	return lv>0 and c:IsRace(RACE_DRAGON) and c:IsAbleToHand() and rg:CheckWithSumEqual(Card.GetLevel,lv,1,99)
end
function c15381421.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c15381421.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c15381421.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c15381421.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local lvt={}
	local pc=1
	for i=1,12 do
		if g:IsExists(c15381421.thfilter,1,nil,i) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg=Duel.GetMatchingGroup(c15381421.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c15381421.thfilter(c,lv)
	return c:IsLevel(lv) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c15381421.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c15381421.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c15381421.thfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsLevel(8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c15381421.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c15381421.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15381421.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c15381421.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c15381421.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
