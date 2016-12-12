--ラプターズ・アルティメット・メイス
function c87609391.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xba))
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(c87609391.thcon)
	e4:SetTarget(c87609391.thtg)
	e4:SetOperation(c87609391.thop)
	c:RegisterEffect(e4)
end
function c87609391.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ec=e:GetHandler():GetEquipTarget()
	local at=Duel.GetAttacker()
	return tc==ec and at and at:GetAttack()>ec:GetAttack()
end
function c87609391.thfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c87609391.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87609391.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87609391.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87609391.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		local tc=Duel.GetAttacker()
		if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsAttackable() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetValue(1)
			e1:SetCondition(c87609391.damcon)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetLabelObject(tc)
			c:GetEquipTarget():RegisterEffect(e1,true)
		end
	end
end
function c87609391.damcon(e)
	return e:GetLabelObject()==Duel.GetAttacker()
end
