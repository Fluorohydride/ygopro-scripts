--ワナビー！
local s,id,o=GetID()
function s.initial_effect(c)
	--sset
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.xfilter(c)
	return c:GetSequence()<5
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5-Duel.GetMatchingGroupCount(s.xfilter,tp,0,LOCATION_SZONE,nil) end
end
function s.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=5-Duel.GetMatchingGroupCount(s.xfilter,tp,0,LOCATION_SZONE,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:FilterCount(s.filter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:FilterSelect(tp,s.filter,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SSet(tp,tc)
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		local turn=Duel.GetTurnCount()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,turn)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.tgcon)
		e1:SetOperation(s.tgop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		g:Sub(sg)
	end
	if #g>0 then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local fid,turn=e:GetLabel()
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(id)==fid and turn~=Duel.GetTurnCount()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
