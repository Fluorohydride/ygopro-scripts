--幻妖フルドラ
---@param c Card
function c81263643.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,81263643)
	e1:SetCost(c81263643.cost)
	e1:SetTarget(c81263643.target)
	e1:SetOperation(c81263643.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c81263643.cfilter(c,tp)
	if not c:IsDiscardable() then return false end
	local ty=c:GetType() & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local log=math.log(ty)/math.log(2)
	return Duel.IsExistingMatchingCard(c81263643.filter,tp,LOCATION_GRAVE,0,1,nil,2 ^ ((log+2) % 3))
end
function c81263643.filter(c,ty)
	return c:IsType(ty) and c:IsAbleToHand()
end
function c81263643.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81263643.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c81263643.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local ty=g:GetFirst():GetType() & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local log=math.log(ty)/math.log(2)
	e:SetLabel(2 ^ ((log+2) % 3))
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c81263643.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c81263643.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81263643.filter),tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
