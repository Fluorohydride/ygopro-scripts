--灰燼のアルバス
---@param c Card
function c37683547.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,68468459,LOCATION_MZONE+LOCATION_GRAVE)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c37683547.condition)
	e1:SetValue(c37683547.atkct)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c37683547.condition)
	e2:SetTarget(c37683547.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,37683547)
	e3:SetCondition(c37683547.spcon)
	e3:SetTarget(c37683547.sptg)
	e3:SetOperation(c37683547.spop)
	c:RegisterEffect(e3)
end
function c37683547.filter(c)
	return c:IsType(TYPE_FUSION) and c:IsLevel(8)
end
function c37683547.condition(e)
	return Duel.IsExistingMatchingCard(c37683547.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c37683547.atkct(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*200
end
function c37683547.tglimit(e,c)
	return c~=e:GetHandler()
end
function c37683547.cfilter(c,tp,rp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function c37683547.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c37683547.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,eg,TYPE_FUSION)
end
function c37683547.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c37683547.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
