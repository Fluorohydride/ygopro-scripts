--暗黒界の登極
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [LOCATION_HAND]=FusionSpell.FUSION_OPERATION_DISCARD },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		extra_target=s.extra_target
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_HANDES)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0
end

function s.fusfilter(c)
	return c:IsRace(RACE_FIEND)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_MZONE|LOCATION_GRAVE
	if tc:IsSetCard(0x6) then
		location=location|LOCATION_HAND
	end
	return location
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end

function s.thfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,s.thfilter,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
