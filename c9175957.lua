--タリホー！スプリガンズ！
---@param c Card
function c9175957.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9175957,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9175957)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9175957.cost)
	e1:SetTarget(c9175957.target)
	e1:SetOperation(c9175957.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9175957,3))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9175957)
	e2:SetTarget(c9175957.mattg)
	e2:SetOperation(c9175957.matop)
	c:RegisterEffect(e2)
end
function c9175957.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(9175957,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,3,REASON_COST)
	end
	e:SetLabel(spct)
end
function c9175957.thfilter(c)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9175957.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9175957.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local spct=e:GetLabel()
	if spct>0 then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_SPSUMMON|CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(e:GetCategory()&~(CATEGORY_GRAVE_SPSUMMON|CATEGORY_SPECIAL_SUMMON))
	end
end
function c9175957.spfilter(c,e,tp)
	return c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9175957.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9175957.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local ct=Duel.GetMatchingGroupCount(aux.NecroValleyFilter(c9175957.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		local spct=e:GetLabel()
		if spct>0 and ct>=spct and ft>=spct
			and Duel.SelectYesNo(tp,aux.Stringid(9175957,2)) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9175957.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,spct,spct,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9175957.matfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c9175957.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9175957.matfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingTarget(c9175957.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9175957.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c9175957.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0
		and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
