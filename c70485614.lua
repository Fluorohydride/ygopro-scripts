--決戦のゴルゴンダ
---@param c Card
function c70485614.initial_effect(c)
	aux.AddCodeList(c,68468459)
	aux.EnableChangeCode(c,60884672,LOCATION_SZONE+LOCATION_GRAVE)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c70485614.reptg)
	e1:SetValue(c70485614.repval)
	e1:SetOperation(c70485614.repop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70485614,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,70485614)
	e2:SetCondition(c70485614.spcon)
	e2:SetTarget(c70485614.sptg)
	e2:SetOperation(c70485614.spop)
	c:RegisterEffect(e2)
end
function c70485614.dfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c70485614.repfilter(c)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and c:IsAbleToGrave()
end
function c70485614.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c70485614.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c70485614.repfilter,tp,LOCATION_EXTRA,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c70485614.repval(e,c)
	return c70485614.dfilter(c,e:GetHandlerPlayer())
end
function c70485614.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c70485614.repfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Hint(HINT_CARD,0,70485614)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
end
function c70485614.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(68468459)
end
function c70485614.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70485614.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c70485614.spfilter(c,e,tp)
	return c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70485614.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c70485614.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c70485614.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c70485614.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
