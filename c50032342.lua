--氷結界の軍師
function c50032342.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50032342,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c50032342.cost)
	e1:SetTarget(c50032342.target)
	e1:SetOperation(c50032342.operation)
	c:RegisterEffect(e1)
end
function c50032342.cfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsSetCard(0x2f) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
	else
		return e:GetHandler():IsSetCard(0x2f) and c:IsAbleToRemove() and c:IsHasEffect(18319762,tp)
	end
end
function c50032342.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50032342.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c50032342.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local te=tc:IsHasEffect(18319762,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.SendtoGrave(tc,REASON_COST)
	end
end
function c50032342.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50032342.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
