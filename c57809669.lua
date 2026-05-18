--見えざる幽獄
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_FUSION_SUMMON|EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.fusfilter(c)
	return c:IsSetCard(0x1d3)
end

function s.ffilter(e,c)
	return c:IsFaceup() and c:GetOwner()==1-e:GetHandlerPlayer()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(s.cfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and (not e:IsCostChecked()
		or Duel.GetFlagEffect(tp,id)==0
			and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x1d3))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_FUSION_SETCODE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.ffilter)
	e1:SetValue(0x1d3)
	Duel.RegisterEffect(e1,tp)
	local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_ONFIELD|LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH },
		},
	})
	local res=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	local b2=res
		and (not e:IsCostChecked()
		or Duel.GetFlagEffect(tp,id+o)==0)
	e1:Reset()
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
			e:SetProperty(EFFECT_FLAG_FUSION_SUMMON)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ADD_FUSION_SETCODE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.ffilter)
		e1:SetValue(0x1d3)
		Duel.RegisterEffect(e1,tp)
		local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
			pre_select_mat_location=LOCATION_ONFIELD|LOCATION_GRAVE,
			mat_operation_code_map={
				{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
				{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH },
			},
		})
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
		e1:Reset()
	end
end
