--U.A.マイティースラッガー
function c56421754.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,56421754)
	e1:SetCondition(c56421754.spcon)
	e1:SetOperation(c56421754.spop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c56421754.aclimit)
	e2:SetCondition(c56421754.actcon)
	c:RegisterEffect(e2)
end
function c56421754.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xb2) and not c:IsCode(56421754) and c:IsAbleToHandAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c56421754.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c56421754.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c56421754.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c56421754.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c56421754.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c56421754.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
