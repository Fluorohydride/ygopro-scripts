--地縛地上絵
function c44710391.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c44710391.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e3)
	--double tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c44710391.dttg)
	e4:SetValue(c44710391.dtval)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44710391,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,44710391)
	e5:SetCondition(c44710391.condition)
	e5:SetTarget(c44710391.target)
	e5:SetOperation(c44710391.operation)
	c:RegisterEffect(e5)
end
function c44710391.indfilter(c)
	return c:IsFaceup() and c:IsLevel(10)
end
function c44710391.indcon(e)
	return Duel.IsExistingMatchingCard(c44710391.indfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c44710391.dttg(e,c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsFaceup() or c:IsControler(e:GetHandlerPlayer()))
end
function c44710391.dtval(e,c)
	return c:IsSetCard(0x1021) and c:IsControler(e:GetHandlerPlayer())
end
function c44710391.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c44710391.thfilter(c)
	return c:IsSetCard(0x1021) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c44710391.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44710391.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44710391.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44710391.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
