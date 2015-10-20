--Dark Doriado
function c62312469.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c62312469.atktg)
	e2:SetValue(c62312469.value)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93368494,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c62312469.thtg)
	e3:SetOperation(c62312469.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c62312469.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_EARTH) or 
	c:IsAttribute(ATTRIBUTE_WIND) 
end
function c62312469.value(e,c)
	return Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetAttribute)*200
end

function c62312469.cfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c62312469.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c62312469.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WIND)
		and Duel.IsExistingMatchingCard(c62312469.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(c62312469.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c62312469.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_EARTH) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c62312469.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_WIND)
	local g2=Duel.SelectTarget(tp,c62312469.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_WATER)
	local g3=Duel.SelectTarget(tp,c62312469.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_FIRE)
	local g4=Duel.SelectTarget(tp,c62312469.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_EARTH)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c62312469.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
end
