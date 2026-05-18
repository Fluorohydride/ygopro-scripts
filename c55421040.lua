--Hunting Horn
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE,
		extra_target=s.target,
		stage_x_operation=s.stage_x_operation,
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not (tc:IsRace(RACE_WARRIOR) and tc:IsAttribute(ATTRIBUTE_EARTH)) then
		Duel.RegisterFlagEffect(tc:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTarget(s.attg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.attg(e,c)
	return not (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH))
end

function s.fusfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end

function s.fusion_spell_matfilter(c)
	return c:IsRace(RACE_WARRIOR)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsBattlePhase() then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	end
end

function s.hand_filter(c)
	return c:IsLocation(LOCATION_HAND)
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage,mg_fusion_spell,mg_all)
	if not Duel.IsBattlePhase() then return end
	if stage==FusionSpell.STAGE_BEFORE_MOVE_MATERIAL then
		--- calculate the count from hand
		local atk_count=mg_all:FilterCount(s.hand_filter,nil)
		if atk_count>0 then
			e:SetLabel(atk_count)
		else
			e:SetLabel(0)
		end
	elseif stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		local atk_count=e:GetLabel()
		if atk_count>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,atk_count,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				for stc in aux.Next(g) do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(math.ceil(stc:GetAttack()/2))
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					stc:RegisterEffect(e1)
				end
			end
		end
	end
end
