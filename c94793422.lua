--心眼の鉾
function c94793422.initial_effect(c)
	aux.AddEquipProcedure(c)
	--damage change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c94793422.damcon)
	e3:SetOperation(c94793422.damop)
	c:RegisterEffect(e3)
end
function c94793422.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler():GetEquipTarget() and ep~=tp
end
function c94793422.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,1000)
end
