--海造賊－荘重のヨルズ号
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetTarget(s.thtg2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
end
function s.GetLegalAttributesOnly(tp)
	local a,attr=1,0
	while a<ATTRIBUTE_ALL do
		local check=true
		for p=0,1 do
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x13f,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,a,POS_FACEUP_DEFENSE,p) then
				check=false
				break
			end
		end
		if check then
			attr=attr|a
		end
		a=a<<1
	end
	return attr
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsAbleToExtra() or Duel.GetMZoneCount(tp,c)<=0
			or Duel.GetMZoneCount(1-tp,c,tp)<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
			return false
		end
		return s.GetLegalAttributesOnly(tp)~=0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local attr=Duel.AnnounceAttribute(tp,1,s.GetLegalAttributesOnly(tp))
	Duel.SetTargetParam(attr)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_EXTRA) then return end
	local attr=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not attr or attr==0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x13f,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,attr,POS_FACEUP_DEFENSE,tp)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x13f,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,attr,POS_FACEUP_DEFENSE,1-tp)
		or Duel.GetMZoneCount(tp,c)<=0 or Duel.GetMZoneCount(1-tp,c,tp)<=0
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		return
	end
	for p in aux.TurnPlayers() do
		local token=Duel.CreateToken(tp,id+o)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.thfilter(c)
	return c:IsSetCard(0x13f) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x13f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.eqfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x13f)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():GetEquipGroup():IsExists(s.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return not e:GetHandler():IsForbidden() and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and c:IsRelateToEffect(e) and not c:IsForbidden() then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
