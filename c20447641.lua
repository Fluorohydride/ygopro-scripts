--機殻の凍結
function c20447641.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c20447641.cost)
	e1:SetTarget(c20447641.target)
	e1:SetOperation(c20447641.activate)
	c:RegisterEffect(e1)
	--triple tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20447641,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(c20447641.ttcon)
	e3:SetTarget(c20447641.tttg)
	e3:SetOperation(c20447641.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e4)
end
function c20447641.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c20447641.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,20447641,0xaa,0x21,1800,1000,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20447641.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,20447641,0xaa,0x21,1800,1000,4,RACE_MACHINE,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:RegisterFlagEffect(20447641,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(c20447641.indtg)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.SpecialSummonComplete()
	end
end
function c20447641.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaa)
end
function c20447641.ttfilter(c)
	return c:GetOriginalCode()==20447641 and c:IsReleasable() and c:GetFlagEffect(20447641)~=0
end
function c20447641.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20447641.ttfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20447641.tttg(e,c)
	return c:IsSetCard(0x10aa)
end
function c20447641.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c20447641.ttfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
