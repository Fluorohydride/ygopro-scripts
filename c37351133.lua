--閃刀姫－ロゼ
function c37351133.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37351133,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37351133)
	e1:SetCondition(c37351133.spcon1)
	e1:SetTarget(c37351133.sptg)
	e1:SetOperation(c37351133.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37351133,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,37351134)
	e3:SetCondition(c37351133.spcon2)
	e3:SetTarget(c37351133.sptg)
	e3:SetOperation(c37351133.spop2)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c37351133.checkop)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
end
function c37351133.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (r&REASON_EFFECT)==0 then return end
	e:SetLabelObject(re)
	local e1=Effect.CreateEffect(e:GetHandler())	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c37351133.resetop)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BREAK_EFFECT)
	e2:SetOperation(c37351133.resetop2)
	e2:SetReset(RESET_CHAIN)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function c37351133.resetop(e,tp,eg,ep,ev,re,r,rp)
	--this will run after EVENT_SPSUMMON_SUCCESS
	e:GetLabelObject():SetLabelObject(nil)
	e:Reset()
end
function c37351133.resetop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:GetLabelObject():SetLabelObject(nil)
	e1:Reset()
	e:Reset()
end
function c37351133.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1115) and not c:IsCode(37351133)
end
function c37351133.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c37351133.cfilter1,1,nil)
end
function c37351133.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c37351133.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37351133.cfilter2(c,tp,rp,se)
	return c:GetPreviousControler()==1-tp and c:GetPreviousSequence()>4 and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_BATTLE) or (rp==tp and c:IsReason(REASON_EFFECT)))
		and (se==nil or c:GetReasonEffect()~=se)
end
function c37351133.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c37351133.cfilter2,1,nil,tp,rp,e:GetLabelObject():GetLabelObject()) and not eg:IsContains(e:GetHandler())
end
function c37351133.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(37351133,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
