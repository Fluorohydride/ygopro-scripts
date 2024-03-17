--奇跡のジュラシック・エッグ
function c63259351.initial_effect(c)
	c:EnableCounterPermit(0x14)
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c63259351.ctcon)
	e2:SetOperation(c63259351.ctop)
	c:RegisterEffect(e2)
	aux.RegisterEachTimeEvent(c,EVENT_TO_GRAVE,c63259351.ctfilter)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c63259351.ctcon2)
	e0:SetOperation(c63259351.ctop2)
	c:RegisterEffect(e0)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(63259351,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c63259351.spcost)
	e3:SetTarget(c63259351.sptg)
	e3:SetOperation(c63259351.spop)
	c:RegisterEffect(e3)
end
function c63259351.ctfilter(c,e,tp)
	return c:IsControler(tp) and c:IsRace(RACE_DINOSAUR)
end
function c63259351.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c63259351.ctfilter,1,nil,e,tp) and not Duel.IsChainSolving()
end
function c63259351.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x14,2)
end
function c63259351.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(63259351)>0
end
function c63259351.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(63259351)
	e:GetHandler():ResetFlagEffect(63259351)
	e:GetHandler():AddCounter(0x14,ct*2)
end
function c63259351.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(0x14))
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c63259351.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_DINOSAUR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c63259351.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c63259351.spfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCounter(0x14),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c63259351.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c63259351.spfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
