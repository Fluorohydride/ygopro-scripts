--覇王天龍の魂
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA|LOCATION_MZONE|LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		extra_target=s.extra_target,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
end

--- @param c Card
function s.costfilter(c,e,tp)
	if not (c:GetBaseAttack()==2500 and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM) and c:IsReleasable(REASON_COST)) then
		return false
	end
	local res_cell=Duel.GetLocationCountFromEx(tp,tp,c,TYPE_FUSION)
	--- Create a temp fusion effect that can not use candidate cost monster as material, if we have a slot on field, skip the location count check
	local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
		fusfilter=s.fusfilter,
		matfilter=function(mc) return mc~=c end,
		pre_select_mat_location=LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA|LOCATION_MZONE|LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		extra_target=s.extra_target,
		skip_location_count_check=(res_cell>0)
	})
	if fusion_effect:GetTarget()(e,tp,nil,nil,nil,nil,nil,nil,0)==false then
		return false
	end
	return true
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,function(c) return s.costfilter(c,e,tp) end,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,function(c) return s.costfilter(c,e,tp) end,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function s.fusfilter(c)
	return c:IsCode(13331639)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:IsCostChecked() then
		--- cost could be paid, location count check done there
		local fusion_effect_no_location_count_check=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
			pre_select_mat_location=LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA|LOCATION_MZONE|LOCATION_GRAVE,
			mat_operation_code_map={
				{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
				{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
			},
			extra_target=s.extra_target,
			skip_location_count_check=true
		})
		return fusion_effect_no_location_count_check:GetTarget()(e,tp,eg,ep,ev,re,r,rp,chk)
	else
		--- cost bypassed, location count check done here
		local fusion_effect_with_location_count_check=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
			pre_select_mat_location=LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA|LOCATION_MZONE|LOCATION_GRAVE,
			mat_operation_code_map={
				{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
				{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
			},
			extra_target=s.extra_target,
			skip_location_count_check=false
		})
		return fusion_effect_with_location_count_check:GetTarget()(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE)
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE then
		local b1=Duel.IsExistingMatchingCard(s.efilter1,tp,LOCATION_REMOVED,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(s.efilter2,tp,LOCATION_REMOVED,0,1,nil)
		local b3=Duel.IsExistingMatchingCard(s.efilter3,tp,LOCATION_REMOVED,0,1,nil)
		local b4=Duel.IsExistingMatchingCard(s.efilter4,tp,LOCATION_REMOVED,0,1,nil)
		if not b1 or not b2 or not b3 or not b4 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
	end
end

function s.efilter1(c)
	return c:IsSetCard(0x10f2) and c:IsFaceup()
end

function s.efilter2(c)
	return c:IsSetCard(0x2073) and c:IsFaceup()
end

function s.efilter3(c)
	return c:IsSetCard(0x2017) and c:IsFaceup()
end

function s.efilter4(c)
	return c:IsSetCard(0x1046) and c:IsFaceup()
end
