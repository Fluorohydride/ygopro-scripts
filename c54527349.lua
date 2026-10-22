--叛逆の堕天使
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		extra_target=s.extra_target,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

--- @param c Card
function s.costfilter(c,e,tp)
	if not (c:IsFaceupEx() and c:IsSetCard(0xef) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()) then
		return false
	end
	local res_cell=Duel.GetLocationCountFromEx(tp,tp,c,TYPE_FUSION)
	--- Create a temp fusion effect that can not use candidate cost monster as material, if we have a slot on field, skip the location count check
	--- stage_x_operation omit as it is only called in operation
	local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
		fusfilter=s.fusfilter,
		matfilter=function(mc) return mc~=c end,
		extra_target=s.extra_target,
		skip_location_count_check=(res_cell>0)
	})
	if fusion_effect:GetTarget()(e,tp,nil,nil,nil,nil,nil,nil,0)==false then
		return false
	end
	return true
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.SendtoGrave(g,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:IsCostChecked() then
		--- cost could be paid, location count check done there
		local fusion_effect_no_location_count_check=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
			extra_target=s.extra_target,
			skip_location_count_check=true
		})
		return fusion_effect_no_location_count_check:GetTarget()(e,tp,eg,ep,ev,re,r,rp,chk)
	else
		--- cost bypassed, location count check done here
		local fusion_effect_with_location_count_check=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
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
	local cat=e:GetCategory()
	local rec=e:GetLabel()
	if e:IsCostChecked() and rec>0 then
		e:SetCategory(cat|CATEGORY_RECOVER)
	else
		--- in case of copy, reset the label
		e:SetLabel(0)
		e:SetCategory(cat&(~CATEGORY_RECOVER))
	end
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		local rec=e:GetLabel()
		if rec>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Recover(tp,rec,REASON_EFFECT)
			e:SetLabel(0)
		end
	end
end
