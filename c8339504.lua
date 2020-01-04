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
	return rk>0 and Duel.IsExistingMatchingCard(c8339504.spfilter1,tp,LOCATION_EXTRA,0,1,nil,rk,c:GetRace(),c:GetAttribute(),c:GetCode(),e,tp,c)
end
function c8339504.spfilter1(c,rk,race,att,code,e,tp,mc)
	return c:IsRank(rk) and c:IsRace(race) and c:IsAttribute(att)
		and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c8339504.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and e:GetHandler():IsCanOverlay()
			and Duel.CheckReleaseGroup(tp,c8339504.cfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c8339504.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetRank(),g:GetFirst():GetRace(),g:GetFirst():GetAttribute(),g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c8339504.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rk,race,att,code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c8339504.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,rk,race,att,code,e,tp,nil)
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
