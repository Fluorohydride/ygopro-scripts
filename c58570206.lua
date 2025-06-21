--多層融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		additional_fcheck=s.additional_fcheck,
		additional_fgoalcheck=s.additional_fgoalcheck,
		pre_select_mat_location=s.pre_select_mat_location,
		mat_operation_code_map={
			{ [LOCATION_EXTRA|LOCATION_GRAVE] = FusionSpell.FUSION_OPERATION_BANISH },
			{ [0xff] = FusionSpell.FUSION_OPERATION_GRAVE }
		},
		stage_x_operation=s.stage_x_operation
	})
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	--- fusion monster must have maximium mertial number >= 3, material_count = {min,max} in metatable
	local mt=getmetatable(c)
	if mt~=nil then
		local material_count=mt.material_count
		if material_count~=nil and #material_count>=2 then
			if material_count[2]<3 then
				return false
			end
		end
	end
	return true
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
		location=location|LOCATION_EXTRA
	end
	return location
end

---@type FUSION_FGCHECK_FUNCTION
function s.additional_fcheck(tp,mg,fc,all_mg)
	--- material from extra deck by this fusion spell can not exceed monster opponent controls
	local count_from_extra=mg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	local monster_count_of_opponet=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if count_from_extra>monster_count_of_opponet then
		return false
	end
	return true
end

---@type FUSION_FGCHECK_FUNCTION
function s.additional_fgoalcheck(tp,mg,fc,all_mg)
	return all_mg:GetCount()>=3
end

---@type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage,mg_fuison_spell,mg_all)
	if stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE then
		local exmat=mg_fuison_spell:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
		if #exmat>0 then
			local dam=exmat:GetSum(Card.GetAttack)
			if dam>0 then
				local lp=Duel.GetLP(tp)
				if lp>=dam then
					Duel.SetLP(tp,lp-dam)
				else
					Duel.SetLP(tp,0)
				end
			end
		end
	end
end
