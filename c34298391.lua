--心を見通す眼
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--check set cards
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.picon)
	e2:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(s.picon)
	e3:SetOperation(s.piopfun(LOCATION_MZONE))
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SSET)
	e4:SetOperation(s.piopfun(LOCATION_SZONE))
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetCondition(s.adjustcon)
	e5:SetOperation(s.adjustop)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetHintTiming(0,TIMING_DRAW+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.accon)
	e6:SetTarget(s.actg)
	e6:SetOperation(s.acop)
	c:RegisterEffect(e6)
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x62)
end
function s.picon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.cfilter2(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TOON)
end
function s.cfilter3(c)
	return c:IsFaceupEx() and c:IsSetCard(0x62) and c:IsType(TYPE_SPELL)
end
function s.accon(e)
	return Duel.IsExistingMatchingCard(s.cfilter2,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter3,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ch=Duel.GetCurrentChain()
	if ch>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local g=Group.CreateGroup()
		for i=1,ch-1 do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			g:AddCard(te:GetHandler())
		end
		local codes={}
		local ag=Group.CreateGroup()
		for c in aux.Next(g) do
			local code=c:GetCode()
			if not ag:IsExists(Card.IsCode,1,nil,code) then
				ag:AddCard(c)
				table.insert(codes,code)
			end
		end
		table.sort(codes)
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			--or ... or c:IsCode(codes[i])
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		table.insert(afilter,OPCODE_NOT)
		ag:Clear()
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	else
		local ac=Duel.AnnounceCard(tp)
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(s.discon)
		e1:SetOperation(s.disop)
		e1:SetLabel(ac,fid)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac,fid=e:GetLabel()
	local ec=e:GetLabelObject()
	return ec:IsFaceupEx()
		and ec:GetFlagEffectLabel(id)==fid
		and re:GetHandler():IsOriginalCodeRule(ac)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.adjustcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():GetFlagEffect(id+o)==0
end
function s.setfilter(c)
	return c:IsFacedown()
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
	e:GetHandler():RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.cffilter(c,tp,loc)
	return c:IsFacedown() and c:IsOnField() and c:IsControler(tp) and c:IsLocation(loc)
end
function s.piopfun(loc)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local sg=eg:Filter(s.cffilter,nil,1-e:GetHandlerPlayer(),loc)
		Duel.ConfirmCards(tp,sg)
	end
end
