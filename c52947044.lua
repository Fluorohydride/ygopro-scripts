--フュージョン・デステニー
function c52947044.initial_effect(c)
	--activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=c52947044.filter,
		mat_location=LOCATION_HAND+LOCATION_DECK,
		fcheck=c52947044.fcheck,
		foperation=c52947044.fop,
		foperation2=c52947044.fop2
	})
	e1:SetCountLimit(1,52947044+EFFECT_COUNT_CODE_OATH)
end
function c52947044.filter(c)
	return aux.IsMaterialListSetCard(c,0xc008)
end
function c52947044.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0xc008)
end
function c52947044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(c52947044.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=c52947044.fcheck
		local res=Duel.IsExistingMatchingCard(c52947044.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c52947044.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c52947044.fop(e,tp,tc)
	tc:RegisterFlagEffect(52947044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(c52947044.descon)
	e1:SetOperation(c52947044.desop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
end
function c52947044.fop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c52947044.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c52947044.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(52947044)~=0
end
function c52947044.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c52947044.splimit(e,c)
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x8))
end
