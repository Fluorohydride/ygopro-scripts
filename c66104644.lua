--マギステル・オブ・エンディミオン
function c66104644.initial_effect(c)
	--Pendulum Summon
	c:EnableCounterPermit(0x1,LOCATION_PZONE+LOCATION_MZONE)
	aux.EnablePendulumAttribute(c)
	c:SetSPSummonOnce(66104644)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c66104644.counterop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66104644,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c66104644.spcost)
	e3:SetTarget(c66104644.sptg)
	e3:SetOperation(c66104644.spop)
	c:RegisterEffect(e3)
	--add counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66104644,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(c66104644.countertg2)
	e4:SetOperation(c66104644.counterop2)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66104644,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c66104644.spcon2)
	e5:SetCost(c66104644.spcost2)
	e5:SetTarget(c66104644.sptg2)
	e5:SetOperation(c66104644.spop2)
	c:RegisterEffect(e5)
	--pendulum set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66104644,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c66104644.pencon)
	e6:SetTarget(c66104644.pentg)
	e6:SetOperation(c66104644.penop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetOperation(c66104644.regop)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
end
function c66104644.counterop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c66104644.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,3,REASON_COST)
end
function c66104644.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanAddCounter(0x1) and Duel.IsCanAddCounter(tp,0x1,1,c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c66104644.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.GetUsableMZoneCount(tp)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsCanAddCounter(tp,0x1,1,c)
		and Duel.IsExistingMatchingCard(c66104644.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_EXTRA)
end
function c66104644.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1
		or Duel.GetUsableMZoneCount(tp)<1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66104644.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		g:AddCard(c)
		for tc in aux.Next(g) do
			tc:AddCounter(0x1,1)
		end
	end
end
function c66104644.countertg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c66104644.counterop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
function c66104644.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c66104644.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
end
function c66104644.spfilter2(c,e,tp)
	return c:IsCanAddCounter(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66104644.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66104644.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66104644.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c66104644.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66104644.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c66104644.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c66104644.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		and ct>0 then
		c:AddCounter(0x1,ct)
	end
end
function c66104644.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetCounter(0x1))
end
