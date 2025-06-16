--黒魔術の秘儀
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	local e0=FusionSpell.CreateSummonEffect(c,{
		additional_fcheck=s.fcheck
	})
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_FUSION_SUMMON)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Must include "Dark Magician" or "Dark Magician Girl"
	if not mg_all:IsExists(function(c) return c:IsFusionCode(46986414,38033121) end,1,nil) then
		return false
	end
	return true
end

function s.rcheck(tp,g,c)
	return g:IsExists(Card.IsCode,1,nil,46986414,38033121)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local fusion_effect=e:GetLabelObject()
	local res1=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	local mg3=Duel.GetRitualMaterial(tp)
	aux.RCheckAdditional=s.rcheck
	local res2=mg3:IsExists(Card.IsCode,1,nil,46986414,38033121)
		and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,aux.TRUE,e,tp,mg3,nil,Card.GetLevel,"Greater")
	aux.RCheckAdditional=nil
	if chk==0 then return res1 or res2 end
	local op=0
	if res1 and not res2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	end
	if not res1 and res2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if res1 and res2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	end
	e:SetLabel(op)
	if op==0 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local fusion_effect=e:GetLabelObject()
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	elseif e:GetLabel()==1 then
		::rcancel::
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=s.rcheck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat then
				aux.RCheckAdditional=nil
				goto rcancel
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
		aux.RCheckAdditional=nil
	end
end
