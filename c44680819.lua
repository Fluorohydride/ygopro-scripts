--ランリュウ
function c44680819.initial_effect(c)
	c:SetUniqueOnField(1,0,44680819)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c44680819.sprcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44680819,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c44680819.spcon)
	e2:SetTarget(c44680819.sptg)
	e2:SetOperation(c44680819.spop)
	c:RegisterEffect(e2)
end
function c44680819.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c44680819.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44680819.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c44680819.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c44680819.spfilter(c,e,tp)
	return c:IsAttack(1500) and c:IsDefense(200) and not c:IsCode(44680819) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44680819.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c44680819.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c44680819.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c44680819.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c44680819.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
