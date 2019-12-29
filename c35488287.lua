--Brotherhood of the Fire Fist - Panda
function c35488287.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35488287,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,35488287)
	e1:SetCondition(c35488287.spcon)
	e1:SetTarget(c35488287.sptg)
	e1:SetOperation(c35488287.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,35488289)
	e2:SetTarget(c35488287.desreptg)
	e2:SetValue(c35488287.desrepval)
	c:RegisterEffect(e2)
end
function c35488287.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x7c)
end
function c35488287.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35488287.spfilter(c,e,tp)
	return c:IsSetCard(0x79) and not c:IsCode(35488287) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35488287.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c35488287.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(35488287,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c35488287.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c35488287.splimit(e,c)
	return not c:IsSetCard(0x79)
end
function c35488287.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x79) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c35488287.tgfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and not c:IsImmuneToEffect(e)
end
function c35488287.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==1-tp and eg:IsExists(c35488287.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c35488287.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c35488287.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c35488287.desrepval(e,c)
	return c35488287.repfilter(c,e:GetHandlerPlayer())
end
