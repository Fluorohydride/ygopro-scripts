--憑依装着－ライナ
function c40542825.initial_effect(c)
	--special summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c40542825.spcon)
	e1:SetOperation(c40542825.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40542825,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40542825.condition)
	e2:SetTarget(c40542825.thtg)
	e2:SetOperation(c40542825.thop)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetCondition(c40542825.condition)
	c:RegisterEffect(e3)
end
function c40542825.spfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(73318863) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c40542825.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c40542825.spfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGraveAsCost()
end
function c40542825.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c40542825.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c40542825.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c40542825.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c40542825.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c40542825.thfilter(c)
	return c:IsDefense(1500) and c:IsRace(RACE_SPELLCASTER) and not c:IsCode(40542825) and c:IsAbleToHand()
end
function c40542825.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c40542825.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40542825.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40542825.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40542825.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
