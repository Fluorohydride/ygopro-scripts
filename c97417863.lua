--DDDD超次元統皇ゼロ・パラドックス
---@param c Card
function c97417863.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--pendulum taking
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,97417863)
	e1:SetTarget(c97417863.pltg)
	e1:SetOperation(c97417863.plop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97417863,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c97417863.spcon)
	e2:SetTarget(c97417863.sptg)
	e2:SetOperation(c97417863.spop)
	c:RegisterEffect(e2)
	--atk 6000
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97417863,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c97417863.atkcon)
	e3:SetTarget(c97417863.atktg)
	e3:SetOperation(c97417863.atkop)
	c:RegisterEffect(e3)
end
function c97417863.pltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_PZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_PZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c97417863.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
		if not tc:IsRelateToEffect(e) then return end
		if not Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(97417863,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		e1:SetCondition(c97417863.descon)
		e1:SetOperation(c97417863.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c97417863.descon(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=ct and tc:GetFlagEffectLabel(97417863)==fid
end
function c97417863.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c97417863.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsFaceup()
end
function c97417863.spcon(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if #pg==0 then return false end
	local pval=pg:GetSum(Card.GetLeftScale)
	local g=eg:Filter(c97417863.cfilter,nil,tp)
	local lv=g:GetSum(Card.GetLevel)
	return #g>0 and lv>0 and pval>lv
end
function c97417863.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c97417863.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	c:CompleteProcedure()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(97417863,1)) then
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c97417863.lefilter(c,tp,re)
	return re and re:IsActiveType(TYPE_SPELL) and c:IsReason(REASON_EFFECT)
		and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x10af)
end
function c97417863.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c97417863.lefilter,1,nil,tp,re) and not eg:IsContains(e:GetHandler())
end
function c97417863.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c97417863.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttack()~=6000 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(6000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
