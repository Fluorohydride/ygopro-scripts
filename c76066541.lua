--ドラゴンダウザー
function c76066541.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76066541,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,76066541)
	e1:SetCondition(c76066541.condition)
	e1:SetTarget(c76066541.target)
	e1:SetOperation(c76066541.operation)
	c:RegisterEffect(e1)
end
function c76066541.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE)
		or rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c76066541.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76066541.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c76066541.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76066541.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76066541.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		aux.epreg(tc,tp,e:GetHandler(),76066541,c76066541.desop)
	end
end
function c76066541.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
