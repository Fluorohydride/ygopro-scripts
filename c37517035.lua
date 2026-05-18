--アルトメギア・マスターワーク－継承－
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		additional_fcheck=s.fcheck,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fscon)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end

function s.fscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Must include one Artmegia monster
	if not mg_all:IsExists(function(c) return c:IsFusionSetCard(0x1cd) end,1,nil) then
		return false
	end
	return true
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

function s.tdfilter(c)
	return c:IsSetCard(0x1cd) and c:IsAbleToDeck() and c:IsCanBeEffectTarget()
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return g:CheckSubGroup(aux.dncheck,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(aux.NecroValleyFilter(),nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
