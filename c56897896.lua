--モノ・シンクロン
function c56897896.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c56897896.synlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_CHECK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c56897896.syncheck)
	c:RegisterEffect(e2)
end
function c56897896.synlimit(e,c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR+RACE_MACHINE)
end
function c56897896.syncheck(e,c)
	if c~=e:GetHandler() then
		c:AssumeProperty(ASSUME_LEVEL,1)
	end
end
