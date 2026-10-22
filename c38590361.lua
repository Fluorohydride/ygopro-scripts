--螺旋融合
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,66889139)
	--fusion summon
	FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
		stage_x_operation=s.stage_x_operation
	})
end

function s.fusfilter(c)
	return c:IsRace(RACE_DRAGON)
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then   --- we need to wait until continues effect apply to know the card name, force register effect
		if tc:IsFaceup() and tc:IsCode(66889139) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1)
			tc:RegisterEffect(e2,true)
		end
	end
end
