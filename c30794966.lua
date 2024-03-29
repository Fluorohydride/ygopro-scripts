--聖刻龍－ウシルドラゴン
function c30794966.initial_effect(c)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c30794966.hspcon)
	e1:SetTarget(c30794966.hsptg)
	e1:SetOperation(c30794966.hspop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c30794966.desreptg)
	e2:SetOperation(c30794966.desrepop)
	c:RegisterEffect(e2)
end
function c30794966.rfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()
		and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsType(TYPE_NORMAL))
end
function c30794966.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c30794966.rfilter,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(aux.gffcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,Card.IsType,TYPE_NORMAL)
end
function c30794966.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c30794966.rfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.gffcheck,true,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,Card.IsType,TYPE_NORMAL)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c30794966.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c30794966.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x69) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c30794966.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.CheckReleaseGroupEx(tp,c30794966.repfilter,1,REASON_EFFECT,false,c) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectReleaseGroupEx(tp,c30794966.repfilter,1,1,REASON_EFFECT,false,c)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c30794966.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_EFFECT)
end
