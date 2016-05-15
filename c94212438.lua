--ウィジャ盤
function c94212438.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94212438,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c94212438.condition)
	e2:SetOperation(c94212438.operation)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c94212438.tgcon)
	e3:SetOperation(c94212438.tgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c94212438.tgop)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e5:SetOperation(c94212438.winop)
	c:RegisterEffect(e5)
end
function c94212438.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(94212438)<4
end
function c94212438.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:GetFlagEffect(94212438)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94212438,1))
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,31893528)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif c:GetFlagEffect(94212438)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94212438,1))
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,67287533)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif c:GetFlagEffect(94212438)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94212438,1))
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,94772232)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif c:GetFlagEffect(94212438)==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94212438,1))
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,30170981)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	c:RegisterFlagEffect(94212438,RESET_EVENT+0x1fe0000,0,0)
end
function c94212438.cfilter2(c,tp)
	return c:IsCode(94212438,31893528,67287533,94772232,30170981) and c:IsControler(tp)
end
function c94212438.cfilter3(c)
	return c:IsFaceup() and c:IsCode(94212438,31893528,67287533,94772232,30170981)
end
function c94212438.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c94212438.cfilter2,1,nil,tp)
end
function c94212438.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c94212438.cfilter3,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c94212438.cfilter1(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c94212438.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DESTINY_BOARD=0x15
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if g:IsExists(c94212438.cfilter1,1,nil,94212438) and g:IsExists(c94212438.cfilter1,1,nil,31893528) and g:IsExists(c94212438.cfilter1,1,nil,67287533)
		 and g:IsExists(c94212438.cfilter1,1,nil,94772232) and g:IsExists(c94212438.cfilter1,1,nil,30170981) then
		Duel.Win(tp,WIN_REASON_DESTINY_BOARD)
 	end
 end
