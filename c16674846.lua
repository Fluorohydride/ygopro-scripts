--スピリット・フォース
---@param c Card
function c16674846.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c16674846.condition)
	e1:SetOperation(c16674846.operation)
	c:RegisterEffect(e1)
end
function c16674846.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>0
end
function c16674846.filter(c)
	return c:IsDefenseBelow(1500) and c:IsType(TYPE_TUNER) and c:IsRace(RACE_WARRIOR)
		and c:IsAbleToHand()
end
function c16674846.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16674846.filter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(16674846,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
