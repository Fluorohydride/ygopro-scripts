--ピュアリィ・マイフレンド
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.thcon2)
	e3:SetTarget(s.thtg2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.thfilter(c)
	return c:IsSetCard(0x18c) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function s.thcfilter(c,tp)
	return c:IsSetCard(0x18c) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp and c:IsType(TYPE_XYZ)
		and not c:IsReason(REASON_RULE)
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thcfilter,1,nil,tp)
end
function s.thfilter2(c)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_GRAVE,0,nil)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	if sg and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end
