--TG サイバー・マジシャン
function c64910482.initial_effect(c)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c64910482.regop)
	c:RegisterEffect(e2)
	--extra hand link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c64910482.hsyntg)
	e3:SetValue(c64910482.matval)
	c:RegisterEffect(e3)
end
function c64910482.hsyntg(e,c,syncard)
	return c:IsSetCard(0x27) and c:IsNotTuner(syncard)
end
function c64910482.matval(e,lc,mg,c,tp)
	return true,not mg or mg:IsContains(e:GetHandler())
end
