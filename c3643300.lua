--伝説のフィッシャーマン
function c3643300.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c3643300.econ)
	e1:SetValue(c3643300.efilter)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c3643300.econ)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c3643300.econ(e)
	return Duel.IsEnvironment(22702055)
end
function c3643300.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
