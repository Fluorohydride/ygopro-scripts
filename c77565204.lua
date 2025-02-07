--未来融合－フューチャー・フュージョン
function c77565204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77565204.reg)
	c:RegisterEffect(e1)
	--Turn 1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c77565204.tgcon)
	e2:SetOperation(c77565204.tgop)
	c:RegisterEffect(e2)
	--Turn 2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77565204.proccon)
	e3:SetOperation(c77565204.procop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c77565204.desop)
	c:RegisterEffect(e4)
	--Destroy2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c77565204.descon2)
	e5:SetOperation(c77565204.desop2)
	c:RegisterEffect(e5)
end
function c77565204.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(c77565204.ctop)
	Duel.RegisterEffect(e1,tp)
	c:CreateEffectRelation(e1)
end
function c77565204.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if not c:IsRelateToEffect(e) or ct>=2 then
		c:SetTurnCounter(0)
		e:Reset()
		return
	end
	if Duel.GetTurnPlayer()~=tp then return end
	ct=ct+1
	c:SetTurnCounter(ct)
end
function c77565204.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetTurnCounter()==1
end
function c77565204.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c77565204.filter2(c,m)
	return c:IsFusionSummonableCard() and c:CheckFusionMaterial(m)
end
function c77565204.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c77565204.filter1,tp,LOCATION_DECK,0,nil,e)
	local sg=Duel.GetMatchingGroup(c77565204.filter2,tp,LOCATION_EXTRA,0,nil,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		mat:KeepAlive()
		Duel.SendtoGrave(mat,REASON_EFFECT)
		for mc in aux.Next(mat) do
			mc:RegisterFlagEffect(77565204,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		e:SetLabel(code)
		e:SetLabelObject(mat)
		Duel.ShuffleExtra(tp)
	end
end
function c77565204.proccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetTurnCounter()==2
end
function c77565204.procfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c77565204.procop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local code=e:GetLabelObject():GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77565204.procfilter,tp,LOCATION_EXTRA,0,1,1,nil,code,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local mat=e:GetLabelObject():GetLabelObject()
	for mc in aux.Next(mat) do
		if mc:GetFlagEffect(77565204)>0 then
			mc:SetReason(REASON_EFFECT+REASON_FUSION+REASON_MATERIAL)
		end
	end
	tc:SetMaterial(mat)
	Duel.SpecialSummon(tc,SUMMON_VALUE_FUTURE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	c:SetCardTarget(tc)
end
function c77565204.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c77565204.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c77565204.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
