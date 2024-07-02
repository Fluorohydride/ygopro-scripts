--未来への沈黙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,79791878)
	--Activate without draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.ndcon)
	e1:SetTarget(s.ndtarget)
	e1:SetOperation(s.ndactivate)
	c:RegisterEffect(e1)
	--Activate without draw
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetCondition(s.dcon)
	e2:SetTarget(s.dtarget)
	e2:SetOperation(s.dactivate)
	c:RegisterEffect(e2)
end
function s.sfilter(c)
	return c:IsFaceup() and c:IsCode(79791878)
end
function s.mfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,79791878) and c:IsType(TYPE_MONSTER)
end
function s.ndcon(e,tp,eg,ep,ev,re,r,rp)
	return not s.dcon(e,tp,eg,ep,ev,re,r,rp)
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
	and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter(c)
	return aux.IsCodeListed(c,79791878) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.ndtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=5-Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())
	local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
		and ct1>0 and Duel.IsPlayerCanDraw(tp,ct1+1)
		and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
end
function s.ndactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.dactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct1>0 or ct2>0 then Duel.BreakEffect() end
	if ct1>0 then Duel.Draw(tp,ct1,REASON_EFFECT) end
	if ct2>0 then Duel.Draw(1-tp,ct2,REASON_EFFECT) end
end