--憑依装着－エリア
--Familiar-Possessed - Eria
function c68881649.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c68881649.spcon)
	e1:SetOperation(c68881649.spop)
	c:RegisterEffect(e1)
end
function c68881649.spfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(74364659) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c68881649.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c68881649.spfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost()
end
function c68881649.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c68881649.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c68881649.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c68881649.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c68881649.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.ShuffleDeck(tp)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
