--ダイナミスト・ハウリング
function c60675348.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(c60675348.activate)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60675348,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c60675348.thcost)
	e2:SetTarget(c60675348.thtg)
	e2:SetOperation(c60675348.thop)
	c:RegisterEffect(e2)
end
function c60675348.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd8) and not c:IsForbidden()
end
function c60675348.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c60675348.filter,tp,LOCATION_DECK,0,nil)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60675348,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,ct,nil)
		local sc=sg:GetFirst()
		while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			sc=sg:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c60675348.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c60675348.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xd8) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c60675348.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xd8) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xd8)
	Duel.Release(g,REASON_COST)
end
function c60675348.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60675348.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
