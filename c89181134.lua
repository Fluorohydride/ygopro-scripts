--捕食植物サンデウ・キンジー
function c89181134.initial_effect(c)
	--fusattribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_FUSION_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c89181134.attrtg)
	e1:SetValue(c89181134.attrval)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),
		include_this_card=true,
		get_extra_mat=c89181134.get_extra_mat,
		reg=false
	})
	e2:SetDescription(aux.Stringid(89181134,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,89181134)
	c:RegisterEffect(e2)
end
function c89181134.attrtg(e,c)
	return c:GetCounter(0x1041)>0
end
function c89181134.attrval(e,c,rp)
	if rp==e:GetHandlerPlayer() then
		return ATTRIBUTE_DARK
	else return c:GetAttribute() end
end
function c89181134.filter(c,e)
	return c:IsCanBeFusionMaterial() and c:IsFaceup() and c:GetCounter(0x1041)>0 and not c:IsImmuneToEffect(e)
end
function c89181134.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c89181134.filter,tp,0,LOCATION_MZONE,nil,e)
end
