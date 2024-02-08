--ペンデュラムーン
function c66150724.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--extra to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66150724,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,66150724)
	e1:SetTarget(c66150724.thtg1)
	e1:SetOperation(c66150724.thop1)
	c:RegisterEffect(e1)
	--to hand 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66150724,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66150725)
	e2:SetTarget(c66150724.thtg2)
	e2:SetOperation(c66150724.thop2)
	c:RegisterEffect(e2)
	if not c66150724.global_check then
		c66150724.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS_G_P)
		ge1:SetOperation(c66150724.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c66150724.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM) then
		Duel.RegisterFlagEffect(rp,66150724,RESET_PHASE+PHASE_END,0,1)
	end
end
function c66150724.thfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xf2) and c:IsAbleToHand()
end
function c66150724.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66150724.thfilter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c66150724.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66150724.thfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		if not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c66150724.thfilter2(c,lsc,rsc)
	if c:IsFacedown() or not c:IsType(TYPE_PENDULUM) then return false end
	local lv=c:GetLevel()
	return lv>lsc and lv<rsc and c:IsAbleToHand()
end
function c66150724.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if not lc or not rc then return false end
		local lsc=lc:GetLeftScale()
		local rsc=rc:GetRightScale()
		if lsc>rsc then lsc,rsc=rsc,lsc end
		return Duel.IsExistingMatchingCard(c66150724.thfilter2,tp,LOCATION_EXTRA,0,1,nil,lsc,rsc)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c66150724.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if lc and rc then
		local lsc=lc:GetLeftScale()
		local rsc=rc:GetRightScale()
		if lsc>rsc then lsc,rsc=rsc,lsc end
		if Duel.IsExistingMatchingCard(c66150724.thfilter2,tp,LOCATION_EXTRA,0,1,nil,lsc,rsc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c66150724.thfilter2,tp,LOCATION_EXTRA,0,1,2,nil,lsc,rsc)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ResetFlagEffect(tp,66150724)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c66150724.discon)
	e1:SetValue(c66150724.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetCondition(c66150724.discon)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c66150724.discon)
	e3:SetOperation(c66150724.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c66150724.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c66150724.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,66150724)==0
end
function c66150724.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and p==tp and bit.band(loc,LOCATION_PZONE)~=0 then
		Duel.NegateEffect(ev)
	end
end