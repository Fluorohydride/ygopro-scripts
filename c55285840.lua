--クロノダイバー・リダン
local s,id,o=GetID()
---@param c Card
function c55285840.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55285840,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c55285840.mattg)
	e1:SetOperation(c55285840.matop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55285840,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,55285840)
	e2:SetTarget(c55285840.target)
	e2:SetOperation(c55285840.operation)
	c:RegisterEffect(e2)
end
function c55285840.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c55285840.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if c:IsRelateToEffect(e) and g:GetCount()==1 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		if tc:IsCanOverlay() then
			Duel.Overlay(c,g)
		else
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
end
function c55285840.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c55285840.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return false end
		local g=c:GetOverlayGroup()
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
			and c:IsAbleToRemove() then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
			and Duel.IsPlayerCanDraw(tp,1) then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP)
			and Duel.IsExistingMatchingCard(c55285840.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) then return true end
		return false
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c55285840.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c55285840.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local g=c:GetOverlayGroup()
	local tg=Group.CreateGroup()
	if c:IsAbleToRemove() then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_MONSTER))
	end
	if Duel.IsPlayerCanDraw(tp,1) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_SPELL))
	end
	if Duel.IsExistingMatchingCard(c55285840.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_TRAP))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=tg:SelectSubGroup(tp,c55285840.check,false,1,3)
	if not sg then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.BreakEffect()
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c55285840.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,c55285840.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(dg,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
function c55285840.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
