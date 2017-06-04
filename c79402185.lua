--ボンディング－D2O
function c79402185.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79402185.cost)
	e1:SetTarget(c79402185.target)
	e1:SetOperation(c79402185.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79402185)
	e2:SetCondition(c79402185.thcon)
	e2:SetTarget(c79402185.thtg)
	e2:SetOperation(c79402185.thop)
	c:RegisterEffect(e2)
end
function c79402185.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsCode,2,nil,43017476)
		and Duel.CheckReleaseGroupEx(tp,Card.IsCode,1,nil,58071123) end
	local g1=Duel.SelectReleaseGroupEx(tp,Card.IsCode,2,2,nil,43017476)
	local g2=Duel.SelectReleaseGroupEx(tp,Card.IsCode,1,1,nil,58071123)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c79402185.filter(c,e,tp)
	return (c:IsCode(85066822) or c:IsCode(6022371)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79402185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c79402185.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c79402185.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79402185.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c79402185.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79402185.thfilter,1,nil)
end
function c79402185.thfilter(c)
	return (c:IsCode(85066822) or c:IsCode(6022371)) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79402185.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c79402185.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
