--ダイス・ダンジョン
---@param c Card
function c11808215.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c11808215.activate)
	c:RegisterEffect(e1)
	--dice roll
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11808215,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c11808215.dicetg)
	e2:SetOperation(c11808215.diceop)
	c:RegisterEffect(e2)
end
c11808215.toss_dice=true
function c11808215.thfilter(c)
	return c:IsCode(47292920) and c:IsAbleToHand()
end
function c11808215.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11808215.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11808215,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c11808215.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c11808215.diceop(e,tp,eg,ep,ev,re,r,rp)
	for p in aux.TurnPlayers() do
		local dice=Duel.TossDice(p,1)
		if dice>=1 and dice<=6 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			local sc=g:GetFirst()
			while sc do
				local atk=sc:GetAttack()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(dice<5 and EFFECT_UPDATE_ATTACK or EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(({-1000,1000,-500,500,math.ceil(atk/2),atk*2})[dice])
				sc:RegisterEffect(e1)
				sc=g:GetNext()
			end
		end
	end
end
