--ダブル・トリガー
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_FUSION_SUMMON)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.fcheck(tp,mg,fc,mg_all,e)
	return mg_all:IsExists(Card.IsFusionSetCard,1,nil,0x102)
end
function s.rcheck(tp,g,c)
	return g:IsExists(Card.IsSetCard,1,nil,0x102)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
		pre_select_mat_location=LOCATION_GRAVE,
		additional_fcheck=s.fcheck
	})
	local b1=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	aux.RCheckAdditional=s.rcheck
	local rg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil,tp)
	local b2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,aux.TRUE,e,tp,Group.CreateGroup(),rg,Card.GetLevel,"Greater")
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o)==0)
	aux.RCheckAdditional=nil
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
	if op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			pre_select_mat_location=LOCATION_GRAVE,
			matfilter=aux.NecroValleyFilter(),
			additional_fcheck=s.fcheck
		})
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	elseif e:GetLabel()==2 then
		::rcancel::
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE,0,nil,tp)
		aux.RCheckAdditional=s.rcheck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,aux.TRUE,e,tp,Group.CreateGroup(),mg,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			end
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
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
