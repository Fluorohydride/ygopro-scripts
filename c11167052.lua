--霊神統一
function c11167052.initial_effect(c)
	aux.AddCodeList(c,61557074)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--indes/untarget
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c11167052.intg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11167052,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c11167052.spcost)
	e4:SetTarget(c11167052.sptg)
	e4:SetOperation(c11167052.spop)
	c:RegisterEffect(e4)
	--discard & salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11167052,1))
	e5:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c11167052.thcon)
	e5:SetCost(c11167052.thcost)
	e5:SetTarget(c11167052.thtg)
	e5:SetOperation(c11167052.thop)
	c:RegisterEffect(e5)
end
function c11167052.intg(e,c)
	return c:IsFaceup() and c:IsCode(61557074)
end
function c11167052.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c11167052.filter1(c,e,tp)
	return Duel.IsExistingMatchingCard(c11167052.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalAttribute())
		and Duel.GetMZoneCount(tp,c)>0
end
function c11167052.filter2(c,e,tp,att)
	return c:IsSetCard(0x400d) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11167052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c11167052.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c11167052.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetOriginalAttribute())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11167052.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11167052.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,att)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11167052.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c11167052.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11167052.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x113) and c:IsAbleToHand()
end
function c11167052.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=hg:GetCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c11167052.thfilter,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,hg,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_GRAVE)
end
function c11167052.thop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11167052.thfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
