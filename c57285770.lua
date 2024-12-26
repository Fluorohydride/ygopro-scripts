--セリオンズ・チャージ
---@param c Card
function c57285770.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,57285770+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c57285770.cost)
	e1:SetTarget(c57285770.target)
	e1:SetOperation(c57285770.activate)
	c:RegisterEffect(e1)
end
function c57285770.costfilter(c)
	return (c:IsSetCard(0x179) or c:IsCode(21887075)) and not c:IsCode(57285770) and c:IsAbleToGraveAsCost()
		and ((c:IsFaceup() and c:GetSequence()<5) or not c:IsLocation(LOCATION_SZONE))
end
function c57285770.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57285770.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c57285770.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c57285770.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c57285770.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
