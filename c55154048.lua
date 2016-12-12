--極星宝ドラウプニル
function c55154048.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c55154048.filter)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55154048,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c55154048.thcon)
	e4:SetTarget(c55154048.thtg)
	e4:SetOperation(c55154048.thop)
	c:RegisterEffect(e4)
end
function c55154048.filter(c)
	return (c:IsSetCard(0x42) or c:IsSetCard(0x4b))
end
function c55154048.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function c55154048.thfilter(c)
	return c:IsSetCard(0x5042) and c:IsAbleToHand()
end
function c55154048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55154048.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55154048.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55154048.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
