--ジェムナイト・クォーツ
---@param c Card
function c35622739.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,35622739)
	e1:SetCondition(c35622739.stcon)
	e1:SetCost(c35622739.stcost)
	e1:SetTarget(c35622739.sttg)
	e1:SetOperation(c35622739.stop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,35622740)
	e2:SetCondition(c35622739.thcon)
	e2:SetTarget(c35622739.thtg)
	e2:SetOperation(c35622739.thop)
	c:RegisterEffect(e2)
end
function c35622739.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c35622739.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c35622739.stfilter(c)
	return c:IsSetCard(0x46) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSSetable()
end
function c35622739.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35622739.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c35622739.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c35622739.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c35622739.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c35622739.splimit(e,c)
	return not c:IsSetCard(0x1047) and c:IsLocation(LOCATION_EXTRA)
end
function c35622739.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and r==REASON_FUSION
end
function c35622739.thfilter(c)
	return not c:IsCode(35622739) and c:IsSetCard(0x1047) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c35622739.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35622739.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c35622739.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35622739.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
