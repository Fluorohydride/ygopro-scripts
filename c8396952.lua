--アルカナフォースⅠ－THE MAGICIAN
---@param c Card
function c8396952.initial_effect(c)
	--coin
	aux.EnableArcanaCoin(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS)
end
function c8396952.arcanareg(c,coin)
	--disable effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c8396952.speop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(FLAG_ID_ARCANA_COIN,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c8396952.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsActiveType(TYPE_SPELL) or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local val=c:GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)
	if val==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	else
		Duel.Recover(1-tp,500,REASON_EFFECT)
	end
end
