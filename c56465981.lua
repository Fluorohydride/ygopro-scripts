--龍相剣現
function c56465981.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56465981,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,56465981)
	e1:SetTarget(c56465981.target)
	e1:SetOperation(c56465981.activate)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56465981,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,56465982)
	e2:SetTarget(c56465981.lvtg)
	e2:SetOperation(c56465981.lvop)
	c:RegisterEffect(e2)
end
function c56465981.thfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and ((check and c:IsRace(RACE_WYRM)) or c:IsSetCard(0x16b))
end
function c56465981.checkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c56465981.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(c56465981.checkfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c56465981.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c56465981.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c56465981.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c56465981.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c56465981.lvfilter(c)
	return (c:IsSetCard(0x16b) or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WYRM))) and c:IsFaceup() and c:GetLevel()>0
end
function c56465981.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c56465981.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c56465981.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c56465981.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c56465981.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sel=0
		local lvl=1
		if tc:IsLevel(1) then
			sel=Duel.SelectOption(tp,aux.Stringid(56465981,2))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(56465981,2),aux.Stringid(56465981,3))
		end
		if sel==1 then
			lvl=-1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
