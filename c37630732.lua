--パワー・ボンド
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
		stage_x_operation=s.stage_x_operation
	})
end

---@param c Card
function s.fusfilter(c)
	return c:IsRace(RACE_MACHINE)
end

---@type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage,mg_fuison_spell,mg_all)
	--- register if the summon is finished
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		-- if base ATK is 0, do nothing
		local atk=tc:GetBaseAttack()
		if atk<=0 then
			return
		end
		---increase ATK
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--- do damage on end phase
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetLabel(tc:GetBaseAttack())
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetOperation(s.damop)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,e:GetLabel(),REASON_EFFECT)
end
