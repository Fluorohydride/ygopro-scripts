--究極融合
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89631139,23995346)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_DECK]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_SHUFFLE }
		},
		stage_x_operation=s.stage_x_operation
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function s.fusfilter(c)
	return aux.IsMaterialListCode(c,89631139)==true or aux.IsMaterialListCode(c,23995346)==true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	if fc.ultimate_fusion_check~=nil then
		if fc.ultimate_fusion_check(tp,mg_all,fc)==false then
			return false
		end
	elseif not (mg_all:IsExists(function(c) return c:IsFusionCode(89631139) end,1,nil) and aux.IsMaterialListCode(fc,89631139)==true
		or mg_all:IsExists(function(c) return c:IsFusionCode(23995346) end,1,nil) and aux.IsMaterialListCode(fc,23995346)==true) then
			return false
	end
	return true
end

function s.desfilter(c)
	return c:IsFusionCode(89631139,23995346) and c:IsOnField()
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage,mg_fuison_spell,mg_all)
	if stage==FusionSpell.STAGE_BEFORE_MOVE_MATERIAL then
		--- calculate the count of 青眼の白龍 and 青眼の究極竜
		local destory_count=mg_all:FilterCount(s.desfilter,nil)
		if destory_count>0 then
			e:SetLabel(destory_count)
		else
			e:SetLabel(0)
		end
	elseif stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		local destory_count=e:GetLabel()
		if destory_count>0 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() end,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,destory_count,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
			e:SetLabel(0)
		end
	end
end
