--佚楽の堕天使
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_GRAVE,
		pre_select_mat_opponent_location=s.pre_select_mat_opponent_location,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		mat_operation_code_map={
			{[LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE},
			{[0xff]=FusionSpell.FUSION_OPERATION_BANISH}
		},
		extra_target=s.extra_target,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
end
function s.fusfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.fusion_spell_matfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup() and c:IsSetCard(0xef))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
function s.pre_select_mat_opponent_location(tc,tp)
	if tc:IsSetCard(0xef) then
		return LOCATION_MZONE
	end
	return 0
end
function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
end
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH and tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
