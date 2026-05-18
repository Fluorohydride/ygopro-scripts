--大融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
		additional_fgoalcheck=s.fgoalcheck,
		stage_x_operation=s.stage_x_operation
	})
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

--- @type FUSION_FGCHECK_FUNCTION
function s.fgoalcheck(tp,mg,tc,mg_all)
	return mg_all:GetCount()>=3
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		--cannot be destroyed
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--pierce
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
		end
	end
end
