--超越竜ギガントザウラー
function c67745632.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR),aux.FilterBoolFunction(Card.IsFusionType,TYPE_NORMAL),true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67745632,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67745632)
	e1:SetTarget(c67745632.thtg)
	e1:SetOperation(c67745632.thop)
	c:RegisterEffect(e1)
	--special summon or self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67745632,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,67745633)
	e2:SetTarget(c67745632.tdtg)
	e2:SetOperation(c67745632.tdop)
	c:RegisterEffect(e2)
end
function c67745632.thfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToHand()
end
function c67745632.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67745632.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67745632.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c67745632.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c67745632.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if e:GetLabel()>0
			and Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)>0
			and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0
			and Duel.SelectYesNo(tp,aux.Stringid(67745632,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			g1:Merge(g2)
			Duel.HintSelection(g1)
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
function c67745632.tdfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToDeck()
end
function c67745632.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67745632.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	if e:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	end
end
function c67745632.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67745632.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		local c=e:GetHandler()
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
			and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0
			and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(67745632,3)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
