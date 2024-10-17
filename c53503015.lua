--冷薔薇の抱香
---@param c Card
function c53503015.initial_effect(c)
	--activate (draw and discard)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53503015,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53503015+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c53503015.cost)
	e1:SetTarget(c53503015.target)
	e1:SetOperation(c53503015.operation)
	c:RegisterEffect(e1)
end
function c53503015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c53503015.cfilter(c,chk,p,chk1,chk2)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and ((chk==0 and c:IsRace(RACE_PLANT)==p)
		or ((c:IsRace(RACE_PLANT) and chk1) or (not c:IsRace(RACE_PLANT) and chk2)))
end
function c53503015.thfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c53503015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chk1=Duel.IsExistingMatchingCard(c53503015.cfilter,tp,LOCATION_MZONE,0,1,nil,0,true)
	local chk2=Duel.IsExistingMatchingCard(c53503015.cfilter,tp,LOCATION_MZONE,0,1,nil,0,false)
		and Duel.IsExistingMatchingCard(c53503015.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and chk1 or chk2
	end
	e:SetLabel(0)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c53503015.cfilter,tp,LOCATION_MZONE,0,1,1,nil,1,nil,chk1,chk2)
	local opt=g:GetFirst():IsRace(RACE_PLANT) and 0 or 1
	Duel.SendtoGrave(g,REASON_COST)
	if opt==0 then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	else
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c53503015.operation(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c53503015.drop)
		Duel.RegisterEffect(e1,tp)
	elseif opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c53503015.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c53503015.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,53503015)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
