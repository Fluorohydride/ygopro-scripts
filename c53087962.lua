--ベアルクティ－セプテン＝トリオン
function c53087962.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c53087962.sprcon)
	e2:SetTarget(c53087962.sprtg)
	e2:SetOperation(c53087962.sprop)
	c:RegisterEffect(e2)
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
function c53087962.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c53087962.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(8)
end
function c53087962.tgrfilter2(c)
	return not c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function c53087962.mnfilter(c,g)
	return g:IsExists(c53087962.mnfilter2,1,c,c)
end
function c53087962.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==7
end
function c53087962.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c53087962.tgrfilter1,1,nil) and g:IsExists(c53087962.tgrfilter2,1,nil)
		and g:IsExists(c53087962.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c53087962.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c53087962.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c53087962.fselect,2,2,tp,c)
end
function c53087962.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c53087962.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c53087962.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c53087962.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.SendtoGrave(tg,REASON_SPSUMMON)
	tg:DeleteGroup()
end
function c53087962.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsLevel(0)
end
function c53087962.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
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
