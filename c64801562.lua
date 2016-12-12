--明鏡止水の心
function c64801562.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c64801562.indval)
	c:RegisterEffect(e3)
	--selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c64801562.descon)
	c:RegisterEffect(e5)
end
function c64801562.indval(e,re,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local rc=re:GetHandler()
	return (re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):IsContains(tc))
		or (re:IsHasType(EFFECT_TYPE_CONTINUOUS) and rc:IsHasCardTarget(tc))
end
function c64801562.descon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:GetAttack()>=1300
end
