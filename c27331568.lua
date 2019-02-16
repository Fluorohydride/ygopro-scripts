--荘厳なる機械天使
function c27331568.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27331568+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c27331568.condition)
	e1:SetCost(c27331568.cost)
	e1:SetTarget(c27331568.target)
	e1:SetOperation(c27331568.activate)
	c:RegisterEffect(e1)
end
function c27331568.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c27331568.cfilter(c,tp)
	return c:IsSetCard(0x2093) and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1)
		and Duel.IsExistingTarget(c27331568.filter,tp,LOCATION_MZONE,0,1,c)
end
function c27331568.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)
end
function c27331568.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c27331568.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c27331568.cfilter,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function c27331568.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c27331568.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c27331568.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c27331568.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetTarget(c27331568.distg)
		e3:SetLabel(tc:GetFieldID())
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		Duel.RegisterEffect(e4,tp)
	end
end
function c27331568.distg(e,c)
	if c:GetFlagEffect(27331568)>0 then return true end
	if c:GetSummonLocation()==LOCATION_EXTRA and c:GetBattleTarget()~=nil and c:GetBattleTarget():GetFieldID()==e:GetLabel() then
		c:RegisterFlagEffect(27331568,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
		return true
	end
	return false
end
