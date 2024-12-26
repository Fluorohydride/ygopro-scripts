--スケアクロー・ライトハート
---@param c Card
function c53776969.initial_effect(c)
	aux.AddCodeList(c,56099748,56063182)
	--link summon
	aux.AddLinkProcedure(c,c53776969.mfilter,1,1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c53776969.thcon)
	e1:SetTarget(c53776969.thtg)
	e1:SetOperation(c53776969.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,53776969+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c53776969.spcon)
	e2:SetTarget(c53776969.sptg)
	e2:SetOperation(c53776969.spop)
	c:RegisterEffect(e2)
end
function c53776969.mfilter(c)
	return (c:IsLinkSetCard(0x17a) or c:IsLinkCode(56099748))
		and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c53776969.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSequence()>4
end
function c53776969.thfilter(c)
	return c:IsCode(56063182) and c:IsAbleToHand()
end
function c53776969.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53776969.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53776969.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53776969.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c53776969.filter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c53776969.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53776969.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c53776969.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53776969.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
