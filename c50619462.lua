--Cattle Call
function c50619462.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50619462+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c50619462.spcost)
	e1:SetTarget(c50619462.sptg)
	e1:SetOperation(c50619462.spop)
	c:RegisterEffect(e1)
end
function c50619462.cfilter(c,e,tp)
	local race=c:GetOriginalRace()
	return c:IsFaceup() and (race==RACE_WINDBEAST or race==RACE_BEAST 
		or race==RACE_BEASTWARRIOR) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c50619462.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,race)
end
function c50619462.spfilter(c,e,tp,race)
	return c:GetOriginalRace()==race and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50619462.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c50619462.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c50619462.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c50619462.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50619462.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50619462.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetOriginalRace())
		local tg=g:GetFirst()
		if tg and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetOperation(c50619462.desop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e4,true)
			Duel.SpecialSummonComplete()
		end
	end
end
function c50619462.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
