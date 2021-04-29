--雷龍融合
function c95238394.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),
		mat_location=LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,
		mat_filter=c95238394.filter,
		mat_operation=aux.FMaterialToDeck,
		grave_operation=aux.FMaterialToDeck,
		mat_operation2=c95238394.matop2
	})
	e1:SetCountLimit(1,95238394)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95238395)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95238394.thtg)
	e2:SetOperation(c95238394.thop)
	c:RegisterEffect(e2)
end
function c95238394.filter(c)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c95238394.matop2(e,tp,mat)
	if mat:IsExists(Card.IsFacedown,1,nil) then
		local cg=mat:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
	end
end
function c95238394.thfilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToHand()
end
function c95238394.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95238394.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95238394.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95238394.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
