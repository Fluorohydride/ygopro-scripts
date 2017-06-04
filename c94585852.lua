--万魔殿－悪魔の巣窟－
function c94585852.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cost change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c94585852.costchange)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c94585852.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(94585852,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CUSTOM+94585852)
	e4:SetTarget(c94585852.target)
	e4:SetOperation(c94585852.operation)
	c:RegisterEffect(e4)
end
function c94585852.costchange(e,re,rp,val)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and re and re:GetHandler():IsSetCard(0x45) and re:GetHandler():IsType(TYPE_MONSTER) then
		return 0
	else
		return val
	end
end
function c94585852.regop(e,tp,eg,ep,ev,re,r,rp)
	local lv1=0
	local lv2=0
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_DESTROY) and not tc:IsReason(REASON_BATTLE) and tc:IsSetCard(0x45) then
			local tlv=tc:GetLevel()
			if tc:IsControler(0) then
				if tlv>lv1 then lv1=tlv end
			else
				if tlv>lv2 then lv2=tlv end
			end
		end
		tc=eg:GetNext()
	end
	if lv1>0 then Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+94585852,e,0,0,0,lv1) end
	if lv2>0 then Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+94585852,e,0,1,1,lv2) end
end
function c94585852.filter(c,lv)
	return c:GetLevel()<lv and c:IsSetCard(0x45) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c94585852.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c94585852.filter,tp,LOCATION_DECK,0,1,nil,ev) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c94585852.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c94585852.filter,tp,LOCATION_DECK,0,1,1,nil,ev)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
