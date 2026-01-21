--法眼の魔術師
function c88757791.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.RegisterSummonFlag(c,EVENT_SPSUMMON_SUCCESS,88757791)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88757791,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c88757791.sctg)
	e1:SetOperation(c88757791.scop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c88757791.indcon)
	e2:SetTarget(c88757791.indtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
end
function c88757791.cfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsPublic()
		and Duel.IsExistingTarget(c88757791.scfilter,tp,LOCATION_PZONE,0,1,nil,c)
end
function c88757791.scfilter(c,pc)
	return c:IsSetCard(0x98) and c:GetLeftScale()~=pc:GetLeftScale()
end
function c88757791.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c88757791.scfilter(chkc,e:GetLabelObject()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c88757791.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c88757791.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(cg:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c88757791.scfilter,tp,LOCATION_PZONE,0,1,1,nil,cg:GetFirst())
end
function c88757791.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local pc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(pc:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(pc:GetRightScale())
		tc:RegisterEffect(e2)
	end
end
function c88757791.indcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(88757791)~=0 and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c88757791.indtg(e,c)
	return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
