--白の聖女エクレシア
function c55273560.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,55273560+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c55273560.sspcon)
	c:RegisterEffect(e1)
	--special summon other monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55273560,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,55273561)
	e2:SetCondition(c55273560.spcon)
	e2:SetCost(c55273560.spcost)
	e2:SetTarget(c55273560.sptg)
	e2:SetOperation(c55273560.spop)
	c:RegisterEffect(e2)
	--grave to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55273560,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,55273562)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c55273560.thcon)
	e3:SetTarget(c55273560.thtg)
	e3:SetOperation(c55273560.thop)
	c:RegisterEffect(e3)
	if not c55273560.global_check then
		c55273560.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c55273560.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c55273560.sspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)
end
function c55273560.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c55273560.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c55273560.spfilter(c,e,tp)
	return (c:IsSetCard(0x16b) or c:IsCode(68468459)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55273560.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c55273560.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c55273560.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55273560.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c55273560.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c55273560.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c55273560.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,55273560,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c55273560.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,55273560,RESET_PHASE+PHASE_END,0,1) end
end
function c55273560.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,55273560)~=0
end
function c55273560.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c55273560.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
