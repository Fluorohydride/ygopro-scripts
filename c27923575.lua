--ブービーゲーム
---@param c Card
function c27923575.initial_effect(c)
	--If a monster(s) battles, you take no damage from that battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27923575,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c27923575.atcon)
	e1:SetOperation(c27923575.atop)
	c:RegisterEffect(e1)
	--If face-down card is destroyed: you can set up to 2 Trap cards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27923575,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,27923575)
	e2:SetCondition(c27923575.setcon)
	e2:SetTarget(c27923575.settg)
	e2:SetOperation(c27923575.setop)
	c:RegisterEffect(e2)
end
function c27923575.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c27923575.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c27923575.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_DESTROY+REASON_EFFECT)==REASON_DESTROY+REASON_EFFECT and rp==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c27923575.setfilter(c)
	return c:GetType()==TYPE_TRAP and not c:IsCode(27923575) and c:IsSSetable()
end
function c27923575.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27923575.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27923575.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local ct=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),2)
	local g=Duel.SelectTarget(tp,c27923575.setfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
end
function c27923575.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #tg==0 or ft<=0 then return end
	if #tg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		tg=tg:Select(tp,1,ft,nil)
	end
	Duel.SSet(tp,tg)
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(27923575,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
