--仇すれば通図
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(s.tdcon)
	e6:SetTarget(s.tdtg)
	e6:SetOperation(s.tdop)
	c:RegisterEffect(e6)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(p,0,LOCATION_ONFIELD)
	local dt=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	ct=math.min(ct,dt)
	if ct==0 then return end
	local t={}
	for i=1,ct do t[i]=i end
	local ac=Duel.AnnounceNumber(p,table.unpack(t))
	Duel.ConfirmDecktop(p,ac)
	local g=Duel.GetDecktopGroup(p,ac)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		if #g>8 then
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
		end
	end
	Duel.BreakEffect()
	local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
	if #hg>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=hg:Select(p,1,1,nil)
		if sg:GetFirst():GetOwner()==p then
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			ac=ac-1
		end
	end
	if ac>0 then
		Duel.SortDecktop(p,p,ac)
		for i=1,ac do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0 and e:GetHandler():GetFlagEffect(id)>0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
