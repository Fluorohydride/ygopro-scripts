--サイバース・ビーコン
---@param c Card
function c91269402.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,91269402+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c91269402.condition)
	e1:SetTarget(c91269402.target)
	e1:SetOperation(c91269402.activate)
	c:RegisterEffect(e1)
	if not c91269402.global_check then
		c91269402.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c91269402.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c91269402.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (bit.band(r,REASON_EFFECT)~=0 and rp==1-ep) or bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,91269402,RESET_PHASE+PHASE_END,0,1)
	end
end
function c91269402.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,91269402)~=0
end
function c91269402.filter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_CYBERSE) and c:IsLevelBelow(4)
end
function c91269402.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91269402.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c91269402.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c91269402.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
