--レイダーズ・アンブレイカブル・マインド
function c87091930.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(87091930,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,87091930)
	e2:SetCondition(c87091930.descon)
	e2:SetTarget(c87091930.destg)
	e2:SetOperation(c87091930.desop)
	c:RegisterEffect(e2)
	--sset
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87091930,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,87091931)
	e3:SetCondition(c87091930.ssetcon)
	e3:SetTarget(c87091930.ssettg)
	e3:SetOperation(c87091930.ssetop)
	c:RegisterEffect(e3)
end
function c87091930.descfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c87091930.descfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSummonPlayer(tp)
		and c:GetMaterial():IsExists(c87091930.descfilter2,1,nil)
end
function c87091930.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87091930.descfilter,1,nil,tp)
end
function c87091930.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local exg=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then exg=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c87091930.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c87091930.ssetcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
		and e:GetHandler():IsReason(REASON_EFFECT)
end
function c87091930.ssetfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x95) and c:IsSSetable()
end
function c87091930.ssettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87091930.ssetfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end
function c87091930.ssetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87091930.ssetfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SSet(tp,g)
	end
end
