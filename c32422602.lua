--戦華の智－諸葛孔
function c32422602.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32422602,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,32422602)
	e1:SetCondition(c32422602.spcon)
	e1:SetTarget(c32422602.sptg)
	e1:SetOperation(c32422602.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32422602,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,32422603)
	e2:SetCondition(c32422602.negcon1)
	e2:SetCost(c32422602.negcost)
	e2:SetTarget(c32422602.negtg)
	e2:SetOperation(c32422602.negop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(32422602,2))
	e3:SetCountLimit(1,32422604)
	e3:SetCondition(c32422602.negcon2)
	c:RegisterEffect(e3)
end
function c32422602.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x137)
		and c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function c32422602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32422602.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c32422602.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c32422602.cfilter(c)
	return c:IsFaceup() and c:IsCode(40428851)
end
function c32422602.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingMatchingCard(c32422602.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c32422602.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x137) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c32422602.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32422602.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c32422602.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c32422602.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c32422602.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
