--敵襲警報－イエローアラート－
---@param c Card
function c59277750.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,59277750+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59277750.condition)
	e1:SetTarget(c59277750.target)
	e1:SetOperation(c59277750.activate)
	c:RegisterEffect(e1)
end
function c59277750.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(1-tp)
end
function c59277750.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59277750.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c59277750.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c59277750.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59277750.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c59277750.atlimit)
		tc:RegisterEffect(e1,true)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(59277750,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetCondition(c59277750.retcon)
		e2:SetOperation(c59277750.retop)
		Duel.RegisterEffect(e2,tp)
		Duel.SpecialSummonComplete()
	end
end
function c59277750.atlimit(e,c)
	return c~=e:GetHandler()
end
function c59277750.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(59277750)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c59277750.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
