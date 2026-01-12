--メガリス・フローチュ
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.srcon)
	e1:SetTarget(s.srtg)
	e1:SetOperation(s.srop)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.rscon)
	e2:SetTarget(s.rstg)
	e2:SetOperation(s.rsop)
	c:RegisterEffect(e2)
end
function s.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.srfilter(c)
	return c:IsSetCard(0x138) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,id+o)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.srfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.rcheck(gc)
	return  function(tp,g,c)
				return g:IsContains(gc)
			end
end
function s.rsfilter(c,e,tp,mg)
	return not c:IsCode(id) and c:IsSetCard(0x138) and aux.RitualUltimateFilter(c,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"Greater")
end
function s.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=s.rcheck(c)
		local res=mg:IsContains(c) and Duel.IsExistingMatchingCard(s.rsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg)
		aux.RCheckAdditional=nil
		return res and Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id+o,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	if c:IsControler(1-tp) or not c:IsRelateToChain() or not mg:IsContains(c) then return end
	::cancel::
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=s.rcheck(c)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.rsfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if not mg:IsContains(c) then
			aux.RCheckAdditional=nil
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		Duel.SetSelectedCard(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			goto cancel
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
end
