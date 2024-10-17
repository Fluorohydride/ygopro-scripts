--溟界の大蛟
---@param c Card
function c96203584.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,96203584)
	e2:SetCost(c96203584.spcost)
	e2:SetTarget(c96203584.sptg)
	e2:SetOperation(c96203584.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,96203585)
	e3:SetCondition(c96203584.tgcon)
	e3:SetTarget(c96203584.tgtg)
	e3:SetOperation(c96203584.tgop)
	c:RegisterEffect(e3)
end
function c96203584.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c96203584.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalAttribute())
end
function c96203584.spfilter(c,e,tp,attr)
	return c:IsRace(RACE_REPTILE) and c:GetOriginalAttribute()~=attr and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c96203584.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96203584.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c96203584.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalAttribute())
	Duel.SendtoGrave(tc,REASON_COST)
end
function c96203584.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local attr=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96203584.spfilter(chkc,e,tp,attr) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c96203584.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,attr)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c96203584.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c96203584.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp)
end
function c96203584.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and eg:IsExists(c96203584.cfilter,1,nil,tp)
end
function c96203584.tgfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToGrave()
end
function c96203584.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96203584.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c96203584.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c96203584.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
