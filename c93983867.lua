--トリック・ボックス
---@param c Card
function c93983867.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c93983867.condition)
	e1:SetTarget(c93983867.target)
	e1:SetOperation(c93983867.activate)
	c:RegisterEffect(e1)
end
function c93983867.cfilter(c,tp)
	return c:IsSetCard(0xc6) and c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c93983867.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c93983867.cfilter,1,nil,tp)
end
function c93983867.spfilter(c,e,tp)
	return c:IsSetCard(0xc6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93983867.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c93983867.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c93983867.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c93983867.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
			tc:RegisterFlagEffect(93983867,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetCondition(c93983867.retcon)
			e1:SetOperation(c93983867.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c93983867.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(93983867)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c93983867.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetLabelObject(tc)
	e1:SetTarget(c93983867.rettg)
	Duel.RegisterEffect(e1,tp)
	--reset
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(e1)
	e2:SetOperation(c93983867.reset)
	Duel.RegisterEffect(e2,tp)
end
function c93983867.rettg(e,c)
	return c==e:GetLabelObject() and c:GetFlagEffect(93983867)~=0
end
function c93983867.reset(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	local tc=e1:GetLabelObject()
	tc:ResetFlagEffect(93983867)
	e1:Reset()
	e:Reset()
end
