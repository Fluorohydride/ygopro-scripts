--熱き決闘者たち
function c88851326.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88851326,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c88851326.atkcon)
	e2:SetTarget(c88851326.atktg)
	e2:SetOperation(c88851326.atkop)
	c:RegisterEffect(e2)
	--prevent set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c88851326.setcon1)
	e3:SetTarget(c88851326.settg)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTargetRange(0,1)
	e4:SetCondition(c88851326.setcon2)
	c:RegisterEffect(e4)
	--prevent attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c88851326.attg)
	c:RegisterEffect(e5)
	--add tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(88851326,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c88851326.thcon)
	e6:SetTarget(c88851326.thtg)
	e6:SetOperation(c88851326.thop)
	c:RegisterEffect(e6)
	--Check for single Set
	if not c88851326.global_check then
		c88851326.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c88851326.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c88851326.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.RegisterFlagEffect(rp,88851326,RESET_PHASE+PHASE_END,0,1)
	end
end
function c88851326.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c88851326.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c88851326.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c88851326.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88851326.atkfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c88851326.atkfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88851326.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c88851326.setcon1(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),88851326)>0
end
function c88851326.setcon2(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),88851326)>0
end
function c88851326.settg(e,c)
	return c:IsLocation(LOCATION_HAND)
end
function c88851326.attg(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c88851326.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c88851326.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88851326.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88851326.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_DRAW)
		e2:SetCondition(c88851326.checkcon1)
		e2:SetOperation(c88851326.checkop1)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c88851326.checkcon1(e,tp,eg,ep,ev,re,r,rp)
	local cid,orig_effect=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID,CHAININFO_TRIGGERING_EFFECT)
	return cid==e:GetLabel() and not e:GetOwner():IsRelateToEffect(orig_effect)
end
function c88851326.checkop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function c88851326.thop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88851326.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
