--憑依装着－ヒータ
---@param c Card
function c4376658.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c4376658.spcon)
	e1:SetTarget(c4376658.sptg)
	e1:SetOperation(c4376658.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(c4376658.condition)
	c:RegisterEffect(e2)
end
function c4376658.spfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c4376658.fselect(g,tp)
	return aux.mzctcheck(g,tp) and aux.gffcheck(g,Card.IsCode,759393,Card.IsAttribute,ATTRIBUTE_FIRE)
end
function c4376658.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c4376658.spfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c4376658.fselect,2,2,tp)
end
function c4376658.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c4376658.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c4376658.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c4376658.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c4376658.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
