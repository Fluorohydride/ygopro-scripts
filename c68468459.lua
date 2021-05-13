--アルバスの落胤
function c68468459.initial_effect(c)
	--fusion summon
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE,
		include_this_card=true,
		get_extra_mat=c68468459.get_extra_mat,
		get_fcheck=c68468459.get_fcheck,
		reg=false
	})
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,68468459)
	e1:SetCondition(c68468459.condition)
	e1:SetCost(c68468459.cost)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c68468459.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&PHASE_DAMAGE==0 and Duel.GetCurrentPhase()&PHASE_DAMAGE_CAL==0
end
function c68468459.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c68468459.filter(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c68468459.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c68468459.filter,tp,0,LOCATION_MZONE,nil,e)
end
function c68468459.chkfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c68468459.get_fcheck(fc,e,tp)
	local c=e:GetHandler()
	return function(tp,sg,fc)
				return not sg:IsExists(c68468459.chkfilter,1,c,tp)
			end
end
