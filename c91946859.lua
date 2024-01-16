--応身の機械天使
function c91946859.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c91946859.indfilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCountLimit(1,91946859)
	e3:SetCondition(c91946859.spcondition)
	e3:SetCost(c91946859.spcost)
	e3:SetTarget(c91946859.sptg)
	e3:SetOperation(c91946859.spop)
	c:RegisterEffect(e3)
end
function c91946859.indfilter(e,c)
	return c:GetType()&0x81==0x81 and c:IsSetCard(0x2093)
end
function c91946859.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0 and rp==1-tp))
end
function c91946859.cfilter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsSetCard(0x2093) and Duel.IsExistingMatchingCard(c91946859.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
end
function c91946859.spfilter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsSetCard(0x2093) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c91946859.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c91946859.cfilter,1,REASON_COST,true,nil,e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c91946859.cfilter,1,1,REASON_COST,true,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c91946859.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91946859.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c91946859.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c91946859.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end
