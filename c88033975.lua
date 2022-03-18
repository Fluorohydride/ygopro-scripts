--幻層の守護者アルマデス
function c88033975.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c88033975.actcon)
	c:RegisterEffect(e1)
end
function c88033975.actcon(e)
	local tc=Duel.GetBattleMonster(e:GetHandlerPlayer())
	return tc and tc==e:GetHandler() and not tc:IsStatus(STATUS_ATTACK_CANCELED)
end
