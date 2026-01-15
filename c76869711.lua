--六花来々
function c76869711.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,76869711)
	e2:SetCondition(c76869711.stcon)
	e2:SetTarget(c76869711.sttg)
	e2:SetOperation(c76869711.stop)
	c:RegisterEffect(e2)
	--release replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_RELEASE_NONSUM)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TRUE)
	e3:SetCountLimit(1)
	e3:SetValue(c76869711.relval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(76869711)
	c:RegisterEffect(e4)
end
function c76869711.filter(c)
	return c:IsSetCard(0x141) and c:IsFaceup()
end
function c76869711.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76869711.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c76869711.stfilter(c)
	return c:IsSetCard(0x141) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c76869711.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c76869711.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c76869711.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c76869711.stfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SSet(tp,tc)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76869711.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c76869711.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c76869711.relval(e,re,r,rp)
	return re:IsActivated() and re:GetHandler():IsSetCard(0x141) and bit.band(r,REASON_COST)~=0
end
