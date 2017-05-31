--RR－ラスト・ストリクス
function c97219708.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97219708,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c97219708.reccon)
	e1:SetTarget(c97219708.rectg)
	e1:SetOperation(c97219708.recop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97219708,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,97219708)
	e2:SetCost(c97219708.spcost)
	e2:SetTarget(c97219708.sptg)
	e2:SetOperation(c97219708.spop)
	c:RegisterEffect(e2)
end
function c97219708.reccon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return (tc:IsControler(tp) and tc:IsSetCard(0xba)) or (at and at:IsControler(tp) and at:IsSetCard(0xba))
end
function c97219708.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*100)
end
function c97219708.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,ct*100,REASON_EFFECT)
		end
	end
end
function c97219708.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c97219708.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c97219708.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c97219708.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c97219708.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c97219708.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(97219708,RESET_EVENT+0x1fe0000,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabel(fid)
			e3:SetLabelObject(tc)
			e3:SetCondition(c97219708.tdcon)
			e3:SetOperation(c97219708.tdop)
			Duel.RegisterEffect(e3,tp)
			Duel.SpecialSummonComplete()
		end
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c97219708.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(97219708)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c97219708.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
