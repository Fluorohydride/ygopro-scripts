--G・B・ハンター
function c4130270.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetTarget(c4130270.etarget)
	c:RegisterEffect(e2)
end
function c4130270.etarget(e,c)
	return bit.band(c:GetOriginalType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)~=0
end
