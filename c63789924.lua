--盗人の煙玉
function c63789924.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Check & Discard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63789924,0))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c63789924.discon)
	e3:SetTarget(c63789924.distg)
	e3:SetOperation(c63789924.disop)
	c:RegisterEffect(e3)
end
function c63789924.discon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41 and e:GetHandler():GetEquipTarget()~=nil and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c63789924.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c63789924.disop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-p)
	end
end
