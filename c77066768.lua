--カードスキャナー
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.AnnounceType(tp))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local sc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
	local oc=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
	Duel.ConfirmCards(tp,sc)
	Duel.ConfirmCards(1-tp,sc)
	Duel.ConfirmCards(tp,oc)
	Duel.ConfirmCards(1-tp,oc)
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if sc:IsType(1<<op) then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
	else Duel.MoveSequence(sc,SEQ_DECKTOP) end
	if oc:IsType(1<<op) then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(oc,nil,REASON_EFFECT,1-tp)
	else Duel.MoveSequence(oc,SEQ_DECKTOP) end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE)
		and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Select(1-tp,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_RULE)
end
