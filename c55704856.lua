--サイバーロード・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE|LOCATION_REMOVED,
		mat_operation_code_map={
			{ [LOCATION_DECK] = FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff] = FusionSpell.FUSION_OPERATION_SHUFFLE }
		},
		additional_fcheck=s.fcheck,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return aux.IsMaterialListSetCard(c,0x1093)
end

---@type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,tc,mg_all)
	if tc.cyber_fusion_check~=nil then
		return tc.cyber_fusion_check(tp,mg_all,tc)
	else
		return true
	end
end

---@type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.ftarget)
		e1:SetLabel(fid)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.ftarget(e,c)
	return e:GetLabel()~=c:GetFlagEffectLabel(id)
end
