--機巧鳥－常世宇受賣長鳴
---@param c Card
function c96399967.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96399967,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,96399967)
	e1:SetCost(c96399967.spcost)
	e1:SetTarget(c96399967.sptg)
	e1:SetOperation(c96399967.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96399967,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,96399968)
	e2:SetTarget(c96399967.thtg)
	e2:SetOperation(c96399967.thop)
	c:RegisterEffect(e2)
end
function c96399967.costfilter(c,e,tp)
	return aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE) and c:GetLevel()>1
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c96399967.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c96399967.spfilter(c,e,tp,lv)
	return aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE)
		and c:GetLevel()<lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c96399967.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c96399967.costfilter,1,nil,e,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c96399967.costfilter,1,1,nil,e,tp)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.Release(sg,REASON_COST)
end
function c96399967.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c96399967.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96399967.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c96399967.thfilter(c)
	return c:IsFacedown() and aux.AtkEqualsDef(c)
		and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c96399967.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96399967.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c96399967.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c96399967.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
