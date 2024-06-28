--クリアー・ワールド
function c33900648.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33900648,4))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33900648.mtcon)
	e2:SetOperation(c33900648.mtop)
	c:RegisterEffect(e2)
	--light
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e4:SetTarget(c33900648.lighttg)
	c:RegisterEffect(e4)
	--dark
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c33900648.darkcon1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCondition(c33900648.darkcon2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
	--earth
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(33900648,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetCondition(c33900648.descon)
	e7:SetTarget(c33900648.destg)
	e7:SetOperation(c33900648.desop)
	c:RegisterEffect(e7)
	--water
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(33900648,2))
	e8:SetCategory(CATEGORY_HANDES)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c33900648.hdcon)
	e8:SetTarget(c33900648.hdtg)
	e8:SetOperation(c33900648.hdop)
	c:RegisterEffect(e8)
	--fire
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(33900648,3))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c33900648.damcon)
	e9:SetTarget(c33900648.damtg)
	e9:SetOperation(c33900648.damop)
	c:RegisterEffect(e9)
	--wind
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_ACTIVATE_COST)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,0)
	e10:SetTarget(c33900648.actarget)
	e10:SetCondition(c33900648.windcon1)
	e10:SetCost(c33900648.costchk)
	e10:SetOperation(c33900648.costop)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetTargetRange(0,1)
	e11:SetCondition(c33900648.windcon2)
	c:RegisterEffect(e11)
end
function c33900648.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33900648.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(33900648,0)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c33900648.attributechk(tp)
	local attchk=0
	if Duel.IsPlayerAffectedByEffect(tp,6089145) then
		attchk=ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND
	else
		local rac=0
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			rac=bit.bor(rac,tc:GetAttribute())
			tc=g:GetNext()
		end
		attchk=rac
	end
	return attchk
end
function c33900648.lighttg(e,c)
	return bit.band(c33900648.attributechk(c:GetControler()),ATTRIBUTE_LIGHT)~=0
		and not Duel.IsPlayerAffectedByEffect(c:GetControler(),97811903)
end
function c33900648.darkcon1(e)
	local tp=e:GetHandlerPlayer()
	return bit.band(c33900648.attributechk(tp),ATTRIBUTE_DARK)~=0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
		and not Duel.IsPlayerAffectedByEffect(tp,97811903)
end
function c33900648.darkcon2(e)
	local tp=e:GetHandlerPlayer()
	return bit.band(c33900648.attributechk(1-tp),ATTRIBUTE_DARK)~=0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=2
		and not Duel.IsPlayerAffectedByEffect(1-tp,97811903)
end
function c33900648.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c33900648.attributechk(Duel.GetTurnPlayer()),ATTRIBUTE_EARTH)~=0
end
function c33900648.desfilter(c)
	return c:IsPosition(POS_FACEUP_DEFENSE)
end
function c33900648.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local turnp=Duel.GetTurnPlayer()
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-turnp,aux.Stringid(33900648,1))
end
function c33900648.desop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if bit.band(c33900648.attributechk(turnp),ATTRIBUTE_EARTH)==0
		or Duel.IsPlayerAffectedByEffect(turnp,97811903) then return end
	Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(turnp,c33900648.desfilter,turnp,LOCATION_MZONE,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c33900648.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c33900648.attributechk(Duel.GetTurnPlayer()),ATTRIBUTE_WATER)~=0
end
function c33900648.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local turnp=Duel.GetTurnPlayer()
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,turnp,1)
	Duel.Hint(HINT_OPSELECTED,1-turnp,aux.Stringid(33900648,2))
end
function c33900648.hdop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if bit.band(c33900648.attributechk(turnp),ATTRIBUTE_WATER)==0
		or Duel.IsPlayerAffectedByEffect(turnp,97811903) then return end
	Duel.DiscardHand(turnp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c33900648.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c33900648.attributechk(Duel.GetTurnPlayer()),ATTRIBUTE_FIRE)~=0
end
function c33900648.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local turnp=Duel.GetTurnPlayer()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,turnp,1000)
	Duel.Hint(HINT_OPSELECTED,1-turnp,aux.Stringid(33900648,3))
end
function c33900648.damop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if bit.band(c33900648.attributechk(turnp),ATTRIBUTE_FIRE)==0
		or Duel.IsPlayerAffectedByEffect(turnp,97811903) then return end
	Duel.Damage(turnp,1000,REASON_EFFECT)
end
function c33900648.windcon1(e)
	local tp=e:GetHandlerPlayer()
	return bit.band(c33900648.attributechk(tp),ATTRIBUTE_WIND)~=0
		and not Duel.IsPlayerAffectedByEffect(tp,97811903)
end
function c33900648.windcon2(e)
	local tp=e:GetHandlerPlayer()
	return bit.band(c33900648.attributechk(1-tp),ATTRIBUTE_WIND)~=0
		and not Duel.IsPlayerAffectedByEffect(1-tp,97811903)
end
function c33900648.actarget(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL)
end
function c33900648.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c33900648.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end