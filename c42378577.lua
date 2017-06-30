--Pendulum Switch
function c42378577.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c42378577.target)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(42378577,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,42378577)
	e2:SetCost(c42378577.cost)
	e2:SetTarget(c42378577.sptg)
	e2:SetOperation(c42378577.spop)
	c:RegisterEffect(e2)
	--place in pen zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(42378577,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,42378577)
	e3:SetCost(c42378577.cost)
	e3:SetTarget(c42378577.pentg)
	e3:SetOperation(c42378577.penop)
	c:RegisterEffect(e3)
end
function c42378577.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c42378577.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		or c42378577.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c42378577.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c42378577.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c42378577.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c42378577.pentg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(42378577,0),aux.Stringid(42378577,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(42378577,0))
		else op=Duel.SelectOption(tp,aux.Stringid(42378577,1))+1 end
		if op==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c42378577.spop)
			c42378577.cost(e,tp,eg,ep,ev,re,r,rp,1)
			c42378577.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(0)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c42378577.penop)
			c42378577.cost(e,tp,eg,ep,ev,re,r,rp,1)
			c42378577.pentg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c42378577.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,42378577)==0 end
	Duel.RegisterFlagEffect(tp,42378577,RESET_PHASE+PHASE_END,0,1)
end
function c42378577.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c42378577.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c42378577.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c42378577.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c42378577.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c42378577.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c42378577.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c42378577.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c42378577.filter(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingTarget(c42378577.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(42378577,2))
	local g=Duel.SelectTarget(tp,c42378577.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c42378577.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
