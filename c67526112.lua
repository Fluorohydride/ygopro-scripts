--ラピッド・トリガー
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		pre_select_mat_location=LOCATION_MZONE,
		mat_operation_code_map={
			{ [LOCATION_ONFIELD|LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND] = FusionSpell.FUSION_OPERATION_DESTROY },
			{ [LOCATION_GRAVE] = FusionSpell.FUSION_OPERATION_BANISH },
			{ [0xff] = FusionSpell.FUSION_OPERATION_GRAVE }
		},
		extra_target=s.extra_target,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DESTROY)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	--- if tp is affected by any EFFECT_CHAIN_MATERIAL effect, it can not be chained with Stardust Dragon
	local chain_material_effects={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CHAIN_MATERIAL)}
	if chain_material_effects~=nil and #chain_material_effects>0 and chain_material_effects[1]~=nil then
		return
	end
	--- FIXME
	--- if tp is affected by any EFFECT_EXTRA_FUSION_MATERIAL, and the EFFECT_EXTRA_FUSION_MATERIAL target range is out of LOCATION_FIELD, it can not be chained with Stardust Dragon
	--- However, current core does not have a method to get the target range of an Effect, fix this once core provides
	--- The same for continues EFFECT_EXTRA_FUSION_MATERIAL like 捕食植物トリアンティス and 魔道騎竜カース・オブ・ドラゴン

	--- Otherwise, this spell will guarantee to destroy 2+ monsters from monster zone.
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,tp,LOCATION_MZONE)
end

---@type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage,mg_fuison_spell,mg_all)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		local c=e:GetHandler()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetValue(s.bttg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(s.immval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
end

function s.bttg(e,c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end

function s.immval(e,te)
	local tc=te:GetOwner()
	return tc~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetActivateLocation()==LOCATION_MZONE and tc:IsSummonLocation(LOCATION_EXTRA)
end
