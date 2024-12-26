--シンクロ・チェイス
---@param c Card
function c23442438.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23442438,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,23442438)
	e2:SetCondition(c23442438.spcon)
	e2:SetTarget(c23442438.sptg)
	e2:SetOperation(c23442438.spop)
	c:RegisterEffect(e2)
	--can not chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c23442438.ccop)
	c:RegisterEffect(e3)
end
function c23442438.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x66,0x1017,0xa3)
end
function c23442438.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c23442438.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23442438.cfilter,1,nil) and rp==tp
end
function c23442438.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(c23442438.cfilter,nil):GetFirst():GetMaterial()
	if chkc then return mg:IsContains(chkc) and c23442438.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and mg:IsExists(c23442438.spfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:FilterSelect(tp,c23442438.spfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c23442438.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c23442438.ccop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if ep==tp and re:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_SYNCHRO) and tc:IsOriginalSetCard(0x66,0x1017,0xa3) then
		Duel.SetChainLimit(c23442438.chainlm)
	end
end
function c23442438.chainlm(e,rp,tp)
	return tp==rp
end
