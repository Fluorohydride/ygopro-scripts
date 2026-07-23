--宇宙的ハリケーン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_HAND)
end
function s.cfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local gs={}
			for p in aux.TurnPlayers() do
				local etg=Group.CreateGroup()
				gs[p]=etg
				if og:IsExists(s.cfilter,1,nil,p) then
					local ct=og:FilterCount(s.cfilter,nil,p)
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
					gs[p]=Duel.GetFieldGroup(p,LOCATION_HAND,0):Select(p,ct,ct,nil)
					Duel.ShuffleHand(p)
				end
			end
			for p in aux.TurnPlayers() do
				local sg=gs[p]
				if sg:GetCount()>0 then
					aux.PlaceCardsOnDeckBottom(p,sg)
				end
			end
		end
	end
end
