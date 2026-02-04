--道化の一座 メテオ
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.sucop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(s.cedop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.sucfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsControler(tp)
end
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(s.sucfilter,1,nil,tp) then return end
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		Duel.RegisterFlagEffect(tp,id+o,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id+o*2)
	e:Reset()
end
function s.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+o*2)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
	Duel.ResetFlagEffect(tp,id+o*2)
end
function s.tdfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToDeck()
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x1dc) and c:IsAbleToHand()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	local b1=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	local b2=Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o)==0)
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
			e:SetCategory(CATEGORY_TODECK)
			e:SetProperty(EFFECT_FLAG_DELAY)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_GRAVE+LOCATION_MZONE)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)
		if aux.NecroValleyNegateCheck(g) then return end
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() and aux.NecroValleyFilter()(tc) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
