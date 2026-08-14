--月女神の至天
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and aux.NegateAnyFilter(chkc) and chkc~=e:GetHandler() end
	local b1=Duel.CheckLPCost(tp,800)
		and e:IsCostChecked() and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	local b2=false
	local og=Group.CreateGroup()
	local ch=Duel.GetCurrentChain()
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	if ch>0 and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+o)==0) then
		local tsp,tse,loc=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
		if tsp and tse and loc then
			og:AddCard(tse:GetHandler())
			b2=tsp==1-tp and tse:IsActiveType(TYPE_MONSTER)
				and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
				and Duel.IsChainDisablable(ev)
		end
	end
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
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		local ct=math.min(math.floor(Duel.GetLP(tp)/800),Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
		Duel.PayLPCost(tp,g:GetCount()*800)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	elseif op==2 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
			e:SetProperty(0)
		end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local c=e:GetHandler()
		local dg=Duel.GetTargetsRelateToChain()
		for tc in aux.Next(dg) do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	elseif e:GetLabel()==2 then
		local ch=Duel.GetCurrentChain()
		Duel.NegateEffect(ch-1)
	end
end
