--アルカナフォースⅣ－THE EMPEROR
---@param c Card
function c61175706.initial_effect(c)
	--coin
	aux.EnableArcanaCoin(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS)
end
function c61175706.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c61175706.atktg)
	e1:SetValue(c61175706.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--
	c:RegisterFlagEffect(FLAG_ID_ARCANA_COIN,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c61175706.atktg(e,c)
	return c:IsSetCard(0x5)
end
function c61175706.atkval(e,c)
	if e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==1 then
		return 500
	else return -500 end
end
