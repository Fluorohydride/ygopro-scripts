--神炎皇ウリア
---@param c Card
function c6007213.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c6007213.spcon)
	e2:SetTarget(c6007213.sptg)
	e2:SetOperation(c6007213.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c6007213.atkval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(6007213,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c6007213.destg)
	e4:SetOperation(c6007213.desop)
	c:RegisterEffect(e4)
end
function c6007213.spfilter(c,check)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_TRAP)
		and (c:IsFaceup() or check and c:IsFacedown())
end
function c6007213.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local check=Duel.IsPlayerAffectedByEffect(tp,16317140)
	local g=Duel.GetMatchingGroup(c6007213.spfilter,tp,LOCATION_ONFIELD,0,nil,check)
	return g:CheckSubGroup(aux.mzctcheck,3,3,tp)
end
function c6007213.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local check=Duel.IsPlayerAffectedByEffect(tp,16317140)
	local g=Duel.GetMatchingGroup(c6007213.spfilter,tp,LOCATION_ONFIELD,0,nil,check)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c6007213.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c6007213.atkfilter(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c6007213.atkval(e,c)
	return Duel.GetMatchingGroupCount(c6007213.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function c6007213.desfilter(c)
	return c:IsFacedown()
end
function c6007213.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c6007213.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6007213.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c6007213.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c6007213.chainlimit)
end
function c6007213.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c6007213.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
