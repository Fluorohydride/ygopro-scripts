--グリフォー
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,33599853)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.effcost)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	--ritual level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_RITUAL_LEVEL)
	e2:SetValue(s.rlevel)
	c:RegisterEffect(e2)
end
function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.setfilter(c)
	return aux.IsCodeListed(c,33599853) and (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	elseif op==2 then
		e:SetCategory(CATEGORY_SSET)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(s.damcon)
		e1:SetValue(s.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
	elseif e:GetLabel()==2 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			if tc:IsType(TYPE_QUICKPLAY) then
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			end
			if tc:IsType(TYPE_TRAP) then
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			end
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,id)==0
end
function s.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function s.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsLevel(8) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
