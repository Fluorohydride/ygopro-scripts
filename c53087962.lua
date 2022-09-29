--ベアルクティ－セプテン＝トリオン
function c53087962.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddGenericSpSummonProcedure(c,LOCATION_EXTRA,c53087962.sprfilter,c53087962.sprgoal,2,2,LOCATION_MZONE,0,nil,HINTMSG_TOGRAVE,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c53087962.distg)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53087962,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,53087962)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c53087962.thcon)
	e4:SetTarget(c53087962.thtg)
	e4:SetOperation(c53087962.thop)
	c:RegisterEffect(e4)
end
function c53087962.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and (c53087962.sprfilter1(c) or c53087962.sprfilter2(c))
end
function c53087962.sprfilter1(c)
	return c:IsLevelAbove(8) and c:IsType(TYPE_TUNER)
end
function c53087962.sprfilter2(c)
	return c:IsLevelAbove(1) and c:IsType(TYPE_SYNCHRO) and not c:IsType(TYPE_TUNER)
end
function c53087962.sprgoal(g,sync)
	if not aux.gffcheck(g,c53087962.sprfilter1,nil,c53087962.sprfilter2,nil) then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return math.abs(c1:GetLevel()-c2:GetLevel())==7
end
function c53087962.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsLevel(0)
end
function c53087962.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c53087962.thfilter(c)
	return c:IsSetCard(0x163) and c:IsAbleToHand()
end
function c53087962.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53087962.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53087962.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53087962.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
