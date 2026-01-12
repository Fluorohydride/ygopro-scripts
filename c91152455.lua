--メタル化・鋼炎装甲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89812483)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,e,tp)
	return aux.IsCodeListed(c,89812483) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,89812483) and c:IsType(TYPE_MONSTER) and not c:IsSummonableCard()
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==100
		return (res or Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 and e:GetLabel()==100
		and c:IsOnField() and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		c:CancelToGrave(true)
		if Duel.Equip(tp,c,tc)~=0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_DESTROY_REPLACE)
			e2:SetTarget(s.destg)
			e2:SetOperation(s.desop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		else
			c:CancelToGrave(false)
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return c:IsAbleToGrave() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
