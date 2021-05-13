--真紅眼融合
function c6172122.initial_effect(c)
	--activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=c6172122.filter,
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,
		get_fcheck=c6172122.get_fcheck,
		foperation=c6172122.fop
	})
	e1:SetCountLimit(1,6172122+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c6172122.cost)
end
function c6172122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(c6172122.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c6172122.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
function c6172122.filter(c)
	return aux.IsMaterialListSetCard(c,0x3b)
end
function c6172122.get_fcheck(fc)
	return fc.red_eyes_fusion_check or c6172122.fcheck
end
function c6172122.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x3b)
end
function c6172122.fop(e,tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(74677422)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
