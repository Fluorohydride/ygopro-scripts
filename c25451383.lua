--黒衣竜アルビオン
function c25451383.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,68468459,LOCATION_MZONE+LOCATION_GRAVE)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25451383,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,25451383)
	e1:SetTarget(c25451383.target)
	e1:SetOperation(c25451383.operation)
	c:RegisterEffect(e1)
end
function c25451383.costfilter(c)
	return (c:IsCode(68468459) or c:IsSetCard(0x15d) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToGraveAsCost()
end
function c25451383.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c25451383.costfilter,tp,LOCATION_HAND,0,1,c)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.IsExistingMatchingCard(c25451383.costfilter,tp,LOCATION_DECK,0,1,nil)
		and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or Duel.IsPlayerCanDraw(tp,1))
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c25451383.costfilter,tp,LOCATION_HAND,0,c)
	local g2=Duel.GetMatchingGroup(c25451383.costfilter,tp,LOCATION_DECK,0,nil)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
	if tc:IsLocation(LOCATION_DECK) and c:IsLocation(LOCATION_HAND) then
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if tc:IsLocation(LOCATION_DECK) and c:IsLocation(LOCATION_GRAVE) then
		e:SetLabel(3)
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c25451383.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if label==2 then
		if Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	if label==3 then
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
