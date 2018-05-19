--エクシーズ・シフト
function c8339504.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8339504+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c8339504.cost)
	e1:SetTarget(c8339504.target)
	e1:SetOperation(c8339504.activate)
	c:RegisterEffect(e1)
end
function c8339504.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c8339504.cfilter(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and Duel.IsExistingMatchingCard(c8339504.spfilter1,tp,LOCATION_EXTRA,0,1,nil,c,e,tp)
end
function c8339504.spfilter1(c,tc,e,tp)
	return c:IsRank(tc:GetRank()) and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute())
		and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8339504.spfilter2(c,tc,e,tp)
	return c:IsRank(tc:GetPreviousRankOnField()) and c:IsRace(tc:GetPreviousRaceOnField()) and c:IsAttribute(tc:GetPreviousAttributeOnField())
		and not c:IsCode(tc:GetPreviousCodeOnField()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8339504.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c8339504.cfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c8339504.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c8339504.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c8339504.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
		local fid=c:GetFieldID()
		sc:RegisterFlagEffect(8339504,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCondition(c8339504.tgcon)
		e1:SetOperation(c8339504.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c8339504.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(8339504)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c8339504.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
