--タツネクロ
function c3096468.initial_effect(c)
	--splimit
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c3096468.splimit)
	c:RegisterEffect(e2)]]
	--hand synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e3:SetCondition(c3096468.syncon)
	e3:SetOperation(c3096468.synop)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
end
function c3096468.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function c3096468.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c3096468.synop(e,tp,sync,mg)
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	return true
end
