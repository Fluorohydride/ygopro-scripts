--睨み統べるスネークアイズ
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x19c) and c:IsLevelAbove(1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetLevel)>1
end
function s.mfilter(c,tp,ft)
	if not (c:IsFaceupEx() and c:IsType(TYPE_MONSTER)) then return false end
	local p=c:GetOwner()
	if p~=tp then ft=0 end
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(p) then r=LOCATION_REASON_CONTROL end
	return Duel.GetLocationCount(p,LOCATION_SZONE,tp,r)>ft
end
function s.sfilter(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_CONTINUOUS+TYPE_SPELL==TYPE_CONTINUOUS+TYPE_SPELL
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(1-tp)
			and s.mfilter(chkc,tp,0)
		else return chkc:IsOnField() and s.sfilter(chkc,e,tp) end
	end
	local ft=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and 1 or 0
	local b1=Duel.IsExistingTarget(s.mfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp,ft)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
		e:SetOperation(s.mvop)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=aux.SelectCardFromFieldFirst(tp,s.mfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tp,0)
		Duel.SetTargetCard(g)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(s.spop)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
