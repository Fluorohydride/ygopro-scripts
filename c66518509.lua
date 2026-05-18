--冥骸融合－メメント・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	-- fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		pre_select_mat_location=s.pre_select_mat_location,
		mat_operation_code_map={
			{ [LOCATION_GRAVE]=FusionSpell.FUSION_OPERATION_SHUFFLE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_GRAVE }
		},
		extra_target=s.extra_target,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		additional_fcheck=s.fcheck,
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	-- destroy and search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.spcfilter(c)
	return c:IsReason(REASON_EFFECT) and (c:IsType(TYPE_MONSTER) or c:IsPreviousLocation(LOCATION_MZONE))
		and not c:IsPreviousLocation(LOCATION_SZONE)
end

function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spcfilter,1,nil)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.spcfilter,nil)
	if g:IsExists(Card.IsPreviousControler,1,nil,0) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	if g:IsExists(Card.IsPreviousControler,1,nil,1) then
		Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if Duel.GetFlagEffect(tp,id)~=0 then
		location=location|LOCATION_GRAVE
	end
	return location
end

function s.fusion_spell_matfilter(c)
	--- materials from grave must be メメント monster
	if c:IsLocation(LOCATION_GRAVE) and not c:IsFusionSetCard(0x1a1) then
		return false
	end
	return true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Must include 1 メメント monster
	if not mg_all:IsExists(function(c) return c:IsFusionSetCard(0x1a1) end,1,nil) then
		return false
	end
	return true
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end

function s.filter(c)
	return c:IsSetCard(0x1a1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
