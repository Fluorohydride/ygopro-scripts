--リヴェンデット・バース
---@param c Card
function c7986397.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7986397+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7986397.target)
	e1:SetOperation(c7986397.activate)
	c:RegisterEffect(e1)
end
function c7986397.dfilter(c)
	return c:IsSetCard(0x106) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c7986397.filter(c,e,tp)
	return c:IsSetCard(0x106)
end
function c7986397.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c7986397.rgcheck(g,ec)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c7986397.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c7986397.dfilter,tp,LOCATION_DECK,0,nil)
		aux.RCheckAdditional=c7986397.rcheck
		aux.RGCheckAdditional=c7986397.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c7986397.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c7986397.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c7986397.dfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c7986397.rcheck
	aux.RGCheckAdditional=c7986397.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c7986397.filter,e,tp,m,dg,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			goto cancel
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(7986397,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c7986397.descon)
		e1:SetOperation(c7986397.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function c7986397.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(7986397)~=0
end
function c7986397.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
