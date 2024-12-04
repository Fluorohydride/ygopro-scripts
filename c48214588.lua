--新風の空牙団
function c48214588.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,48214588+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c48214588.cost)
	e1:SetTarget(c48214588.target)
	e1:SetOperation(c48214588.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(48214588,ACTIVITY_ATTACK,c48214588.counterfilter)
end
function c48214588.counterfilter(c)
	return c:IsSetCard(0x114)
end
function c48214588.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.GetCustomActivityCount(48214588,tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c48214588.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c48214588.atktg(e,c)
	return not c:IsSetCard(0x114)
end
function c48214588.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c48214588.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,lv,e,tp)
end
function c48214588.spfilter(c,lv,e,tp)
	return c:IsLevel(lv+1,lv-1) and c:IsSetCard(0x114) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c48214588.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c48214588.cfilter,1,nil,e,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c48214588.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c48214588.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c48214588.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
