--オルターガイスト・プライムバンシー
function c93503294.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x103),2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93503294,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,93503294)
	e1:SetCondition(c93503294.spcon)
	e1:SetCost(c93503294.spcost)
	e1:SetTarget(c93503294.sptg)
	e1:SetOperation(c93503294.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93503294,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c93503294.thcon)
	e2:SetTarget(c93503294.thtg)
	e2:SetOperation(c93503294.thop)
	c:RegisterEffect(e2)
end
function c93503294.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c93503294.spcfilter(c,g,zone)
	return c:IsSetCard(0x103) and (zone~=0 or g:IsContains(c))
end
function c93503294.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetLinkedZone()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c93503294.spcfilter,1,c,lg,zone) end
	local tc=Duel.SelectReleaseGroup(tp,c93503294.spcfilter,1,1,c,lg,zone):GetFirst()
	if lg:IsContains(tc) then
		e:SetLabel(tc:GetSequence())
	end
	Duel.Release(tc,REASON_COST)
end
function c93503294.spfilter0(c,e,tp)
	return c:IsSetCard(0x103) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93503294.spfilter1(c,e,tp,zone)
	return c:IsSetCard(0x103) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c93503294.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		if zone~=0 then
			return Duel.IsExistingMatchingCard(c93503294.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
		else
			return Duel.IsExistingMatchingCard(c93503294.spfilter0,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c93503294.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93503294.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c93503294.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c93503294.thfilter(c)
	return c:IsSetCard(0x103) and c:IsAbleToHand()
end
function c93503294.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c93503294.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c93503294.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c93503294.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c93503294.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
