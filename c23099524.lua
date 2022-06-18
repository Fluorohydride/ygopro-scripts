--ファラオニック・アドベント
function c23099524.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23099524,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,23099524)
	e1:SetCost(c23099524.spcost)
	e1:SetTarget(c23099524.sptg)
	e1:SetOperation(c23099524.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c23099524.atkval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23099524,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,23099525)
	e3:SetCost(c23099524.thcost)
	e3:SetTarget(c23099524.thtg)
	e3:SetOperation(c23099524.thop)
	c:RegisterEffect(e3)
end
function c23099524.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c23099524.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c23099524.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c23099524.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c23099524.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c23099524.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c23099524.atkfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c23099524.atkval(e,c)
	return Duel.GetMatchingGroupCount(c23099524.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)*300
end
function c23099524.thcfilter(c,tp)
	return c:IsRace(RACE_FAIRY+RACE_FIEND+RACE_REPTILE) and (c:IsFaceup() or c:IsControler(tp))
end
function c23099524.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c23099524.thcfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c23099524.thcfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c23099524.thfilter(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsAbleToHand()
end
function c23099524.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23099524.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23099524.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23099524.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
