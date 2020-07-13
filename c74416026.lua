--デストーイ・マーチ
function c74416026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c74416026.condition)
	e1:SetTarget(c74416026.target)
	e1:SetOperation(c74416026.activate)
	c:RegisterEffect(e1)
end
function c74416026.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xad)
end
function c74416026.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c74416026.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c74416026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c74416026.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c74416026.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c74416026.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_FUSION) and c:IsLevelAbove(8) and c:IsSetCard(0xad)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial() and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c74416026.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c74416026.filter,nil,tp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local tg=g:Filter(Card.IsRelateToEffect,nil,re)
		if tg:IsExists(c74416026.tgfilter,1,nil,e,tp) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
			and Duel.SelectYesNo(tp,aux.Stringid(74416026,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc=tg:FilterSelect(tp,c74416026.tgfilter,1,1,nil,e,tp):GetFirst()
			if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c74416026.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
			sc:SetMaterial(nil)
			if Duel.SpecialSummonStep(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				local c=e:GetHandler()
				local fid=c:GetFieldID()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabelObject(sc)
				e1:SetCondition(c74416026.rmcon)
				e1:SetOperation(c74416026.rmop)
				if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then
					e1:SetLabel(Duel.GetTurnCount(),fid)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
					sc:RegisterFlagEffect(74416026,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2,fid)
				else
					e1:SetLabel(0,fid)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
					sc:RegisterFlagEffect(74416026,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1,fid)
				end
				Duel.RegisterEffect(e1,tp)
				Duel.SpecialSummonComplete()
				sc:CompleteProcedure()
			end
		end
	end
end
function c74416026.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local turn,fid=e:GetLabel()
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=turn and tc:GetFlagEffectLabel(74416026)==fid
end
function c74416026.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
