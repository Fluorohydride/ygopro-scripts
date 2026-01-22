--糾罪都市－エニアポリス
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--to hand
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_FLIP)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(custom_code)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.pthcon)
	e3:SetTarget(s.pthtg)
	e3:SetOperation(s.pthop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d4) and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_ONFIELD,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.pthfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x1d4) and c:IsControler(tp) and c:IsFaceup()
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0)
		or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		or c:IsAbleToHand())
end
function s.pthcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.pthfilter,1,nil,tp)
		and Duel.IsMainPhase()
end
function s.pthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.pthfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
end
function s.pthop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.pthfilter,nil,tp)
	local mg=g:Filter(Card.IsRelateToChain,nil)
	if mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local og=mg:Select(tp,1,1,nil)
		local tc=og:GetFirst()
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=tc:IsAbleToHand()
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,3),1},
			{b2,aux.Stringid(id,4),2})
		if op==1 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.HintSelection(og)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetCounter(tp,1,0,0x71)>0 then
		local dam=Duel.GetCounter(tp,1,0,0x71)*900
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(dam)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
end
function s.ctfilter(c)
	return c:GetCounter(0x71)>0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	local rmct=0
	while tc do
		local ct=tc:GetCounter(0x71)
		rmct=rmct+ct
		tc:RemoveCounter(tp,0x71,ct,REASON_EFFECT)
		tc=g:GetNext()
	end
	if rmct>0 then
		Duel.Damage(1-tp,rmct*900,REASON_EFFECT)
	end
end
