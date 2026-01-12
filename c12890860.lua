--拒神ドゥータン
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunction(aux.NOT(Card.IsLocation),LOCATION_ONFIELD+LOCATION_GRAVE),2,true)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(s.indcon2)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.rmcost)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.cfilter(c,tp)
	return c:IsFaceupEx() and Duel.IsExistingMatchingCard(s.codefilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,c:GetOriginalCode())
end
function s.codefilter(c,code)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:GetOriginalCode()==code
end
function s.indcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
end
function s.cfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.codefilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,c:GetOriginalCode())
		and c:IsAbleToGraveAsCost()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectTargetFromFieldFirst(tp,s.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
