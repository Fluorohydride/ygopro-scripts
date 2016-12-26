--EMドラマチックシアター
function c55553602.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c55553602.atkvalue)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c55553602.condition)
	e3:SetTarget(c55553602.target)
	e3:SetOperation(c55553602.operation)
	c:RegisterEffect(e3)
end
function c55553602.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function c55553602.atkvalue(e,c)
	local g=Duel.GetMatchingGroup(c55553602.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetRace)
	return ct*200
end
function c55553602.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:GetRace()~=0
end
function c55553602.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55553602.confilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetRace)
	return ct==4
end
function c55553602.spfilter(c,e,sp)
	return c:IsSetCard(0x99) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c55553602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55553602.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c55553602.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c55553602.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
