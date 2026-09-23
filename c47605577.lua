--レイズ・ムーンの朔 スクイーズ
local s,id,o=GetID()
function s.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if not tc:IsReason(REASON_DRAW) and tc:IsPreviousLocation(LOCATION_DECK) then
			Duel.RegisterFlagEffect(rp,id,0,0,1)
		end
	end
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0
		and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	Duel.RegisterEffect(e1,tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o)==0)
	local b2=Duel.IsPlayerCanDraw(tp,1)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o*2)==0)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==2 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCondition(s.drcon1)
		e1:SetOperation(s.drop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCondition(s.regcon)
		e2:SetOperation(s.regop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(s.drcon2)
		e3:SetOperation(s.drop2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(id,4))
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4:SetTargetRange(1,0)
		e4:SetTarget(s.splimit)
		e4:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e4,tp)
		-- draw in chain while spsummoning
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(s.chaindrawcon)
		e5:SetOperation(s.procdraw)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetProperty(EFFECT_FLAG_DELAY)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetCondition(s.succon)
		e6:SetOperation(s.procdraw)
		e6:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(e7,tp)
	elseif e:GetLabel()==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function s.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW)
end
function s.procfilter(c,tp)
	return s.cfilter(c,tp) and c:IsReason(REASON_SPSUMMON)
end
function s.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not Duel.IsChainSolving()
end
function s.drop1(e,tp,eg,ep,ev,re,r,rp)
	-- raise event for REASON_SPSUMMON
	if eg:IsExists(s.procfilter,1,nil,tp) then
		Duel.RegisterFlagEffect(tp,id+o*4,RESET_PHASE+PHASE_END,0,1)
		return
	end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.chaindrawcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and Duel.GetFlagEffect(tp,id+o*4)>0
end
function s.succon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+o*4)>0 and not Duel.IsChainSolving()
end
function s.procdraw(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,id+o*4)
	Duel.ResetFlagEffect(tp,id+o*4)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id+o*3,RESET_CHAIN,0,1)
end
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+o*3)>0
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,id+o*3)
	Duel.ResetFlagEffect(tp,id+o*3)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function s.splimit(e,c)
	return not (c:IsRank(7) and c:IsType(TYPE_XYZ)) and c:IsLocation(LOCATION_EXTRA)
end
