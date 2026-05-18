--ダイノルフィア・フレンジー
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_DECK|LOCATION_EXTRA,
		extra_target=s.extra_target,
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.cdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.cdop)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function s.fusfilter(c)
	--- We can filter with material_count from metatable but as of now all ダイノルフィア Fusion Monster has 2 materials
	return c:IsSetCard(0x173)
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	if #mg_all>2 then
		return false
	end
	if mg_all:FilterCount(function(c) return c:IsLocation(LOCATION_DECK) end,nil)~=1 then
		return false
	end
	if mg_all:FilterCount(function(c) return c:IsLocation(LOCATION_EXTRA) end,nil)~=1 then
		return false
	end
	return true
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA)
end

function s.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and rp==1-tp
end

function s.cdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function s.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetOwnerPlayer() then return 0
	else return val end
end
