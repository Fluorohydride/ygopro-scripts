--天空神騎士ロードパーシアス
function c48589580.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(48589580,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,48589580)
	e1:SetCost(c48589580.thcost)
	e1:SetTarget(c48589580.thtg)
	e1:SetOperation(c48589580.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48589580,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,48589581)
	e2:SetCondition(c48589580.spcon)
	e2:SetCost(c48589580.spcost)
	e2:SetTarget(c48589580.sptg)
	e2:SetOperation(c48589580.spop)
	c:RegisterEffect(e2)
end
function c48589580.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c48589580.thfilter(c,thchk)
	return (c:IsCode(56433456) or aux.IsCodeListed(c,56433456) or (thchk and c:IsRace(RACE_FAIRY))) and c:IsAbleToHand()
end
function c48589580.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local thchk=Duel.IsEnvironment(56433456)
	if chk==0 then return Duel.IsExistingMatchingCard(c48589580.thfilter,tp,LOCATION_DECK,0,1,nil,thchk) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c48589580.thop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(56433456)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c48589580.thfilter,tp,LOCATION_DECK,0,1,1,nil,thchk)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c48589580.cfilter(c,tp)
	return bit.band(c:GetPreviousRaceOnField(),RACE_FAIRY)~=0 and c:IsRace(RACE_FAIRY)
		and c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_MZONE and c:IsPreviousPosition(POS_FACEUP)
end
function c48589580.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48589580.cfilter,1,nil,tp)
end
function c48589580.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c48589580.costfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsRace(RACE_FAIRY) and Duel.IsExistingMatchingCard(c48589580.spfilter,tp,LOCATION_HAND,0,1,nil,lv+1,e,tp)
end
function c48589580.spfilter(c,lv,e,tp)
	return c:IsLevelAbove(lv) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c48589580.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c48589580.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c48589580.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c48589580.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c48589580.spfilter,tp,LOCATION_HAND,0,1,1,nil,lv+1,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
