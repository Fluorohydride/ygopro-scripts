--魂の結束－ソウル・ユニオン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.atkfilter(c)
	return c:IsSetCard(0x3008) and c:IsType(TYPE_MONSTER) and c:GetAttack()>0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end

function s.fusfilter(c)
	return c:IsSetCard(0x3008)
end

function s.cfilter(c)
	return c:IsSetCard(0x3008) and c:IsType(TYPE_NORMAL)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local stg=Duel.GetTargetsRelateToChain()
	local mc=stg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetFirst()
	local gc=stg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if not mc or not gc then return end
	if not mc:IsImmuneToEffect(e) then
		local atk=gc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		mc:RegisterEffect(e1)
		if not mc:IsHasEffect(EFFECT_REVERSE_UPDATE)
			and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then
			local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
				fusfilter=s.fusfilter,
				pre_select_mat_location=LOCATION_GRAVE,
				mat_operation_code_map={
					{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
					{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH },
				},
			})
			if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0) then
				if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.BreakEffect()
					fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
				end
			end
		end
	end
end
