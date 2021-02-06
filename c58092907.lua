--EM天空の魔術師
function c58092907.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58092907,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,58092907)
	e1:SetCondition(c58092907.spcon)
	e1:SetTarget(c58092907.sptg)
	e1:SetOperation(c58092907.spop)
	c:RegisterEffect(e1)
	--monster effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58092907,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,58092908)
	e2:SetCondition(c58092907.mecon)
	e2:SetTarget(c58092907.metg)
	e2:SetOperation(c58092907.meop)
	c:RegisterEffect(e2)
	if not c58092907.global_check then
		c58092907.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetLabel(58092907)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(58092907)
		Duel.RegisterEffect(ge2,0)
	end
end
function c58092907.spfilter(c,tp,rp)
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp==1-tp)) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:IsSummonLocation(LOCATION_EXTRA)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)~=0 and c:IsPreviousPosition(POS_FACEUP)
end
function c58092907.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(c58092907.spfilter,1,nil,tp,rp)
end
function c58092907.spfilter2(c,e,tp)
	if c:IsLocation(LOCATION_HAND+LOCATION_DECK) or (not c:IsLocation(LOCATION_GRAVE) and c:IsFacedown())
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsControler(1-tp) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function c58092907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return c58092907.spfilter2(ec,e,tp) end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ec,1,0,0)
end
function c58092907.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.GetFirstTarget()
	if ec:IsRelateToEffect(e) and Duel.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c58092907.mefilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c58092907.mefilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c58092907.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c58092907.mecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(58092907)>0
end
function c58092907.metg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58092907.mefilter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
		or (Duel.IsExistingMatchingCard(c58092907.mefilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_PENDULUM)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c58092907.cfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function c58092907.meop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c58092907.mefilter1,tp,LOCATION_MZONE,0,aux.ExceptThisCard(e))
	local b1=c:IsRelateToEffect(e) and g:IsExists(c58092907.cfilter,1,nil,TYPE_FUSION)
	local b2=g:IsExists(c58092907.cfilter,1,nil,TYPE_SYNCHRO)
	local b3=c:IsRelateToEffect(e) and c:IsFaceup() and g:IsExists(c58092907.cfilter,1,nil,TYPE_XYZ)
	local b4=Duel.IsExistingMatchingCard(c58092907.mefilter2,tp,LOCATION_MZONE,0,1,aux.ExceptThisCard(e))
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_PENDULUM)
	if b1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if b2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(c58092907.actlimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if b3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(c:GetBaseAttack()*2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
	if b4 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetCondition(c58092907.thcon)
		e4:SetOperation(c58092907.thop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c58092907.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c58092907.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c58092907.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c58092907.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,58092907)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c58092907.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
